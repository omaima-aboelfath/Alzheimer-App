from flask import Flask, jsonify, request , render_template, send_from_directory
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
matplotlib.use('Agg')  # Use a non-GUI backend for Flask
import matplotlib.pyplot as plt
import plotly.express as px
import plotly.graph_objs as go
import json
import plotly
import statsmodels
from statsmodels.tsa.arima.model import ARIMA
from scipy.stats import linregress
import numpy as np
import sys
import functools
import io  # Import the io module
import base64
import os
import logging
import re


# Force logs to flush immediately
print = functools.partial(print, flush=True)
# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

app = Flask(__name__, template_folder='.')
CORS(app)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("C:/Users/xneemoox/Desktop/graduation project/alzheimer-app-6fada-firebase-adminsdk-ry2po-b5a48bf2c5.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Ensure the 'charts' directory exists
os.makedirs('charts', exist_ok=True)

# @app.route('/users/<string:user_id>/tasks', methods=['GET'])
# def get_tasks_for_user(user_id):
#     try:
#         user_ref = db.collection('users').document(user_id)
#         tasks_ref = user_ref.collection('tasks')
#         tasks = tasks_ref.stream()

#         tasks_list = []
#         for task in tasks:
#             task_data = task.to_dict()
#             task_data['id'] = task.id  # Include task ID
#             tasks_list.append(task_data)

#         return tasks_list  # Return the list of tasks directly, not a Flask response
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

@app.route('/users/<user_id>/tasks-summary', methods=['GET'])
def get_task_summary(user_id):
    try:
        # Fetch tasks for the user
        tasks_data = get_tasks_for_user(user_id)  # Now this will return a list of tasks
        
        if isinstance(tasks_data, list):  # Ensure the data is in the correct format
            df = pd.DataFrame(tasks_data)
            df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')  # Convert from milliseconds
            
            # Aggregate the data into daily counts of completed/incomplete tasks
            df['date'] = df['dateTime'].dt.date
            task_summary = df.groupby('date')['isDone'].value_counts().unstack(fill_value=0).to_dict()

            # Convert to desired format for Flutter
            result = {}
            for date, counts in task_summary.items():
                result[str(date)] = {
                    'complete': counts.get(True, 0),
                    'incomplete': counts.get(False, 0),
                }

            return jsonify(result)
        else:
            return jsonify({"error": "Failed to fetch tasks"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/users/<user_id>/tasks-summary-chart', methods=['GET'])
def get_task_summary_chart(user_id):
    try:
        # Fetch tasks for the user
        tasks_data = get_tasks_for_user(user_id)
        
        if isinstance(tasks_data, list):  # Ensure the data is in the correct format
            df = pd.DataFrame(tasks_data)
            if df.empty:
                return jsonify({"error": "No tasks found for the user"}), 404
            
            # Convert timestamp and group data
            df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')  # Convert from milliseconds
            if 'isDone' not in df.columns:
                return jsonify({"error": "Tasks data is missing the 'isDone' field"}), 500

            # Aggregate the data by date and task completion status
            df['date'] = df['dateTime'].dt.date
            task_summary = df.groupby('date')['isDone'].value_counts().unstack(fill_value=0)
            
            # Ensure numeric data for plotting
            task_summary = task_summary.astype(int)

            # Add missing columns if necessary
            if True not in task_summary.columns:
                task_summary[True] = None  # Skip plotting
            if False not in task_summary.columns:
                task_summary[False] = None  # Skip plotting
        
            # Plotting the time series chart
            plt.figure(figsize=(10, 6))

            # Plot completed tasks if available
            if True in task_summary.columns and task_summary[True].sum() > 0:
                task_summary[True].plot(label="Completed Tasks", marker='o', linestyle='-', color='g')
            
            # Plot incomplete tasks if available
            if False in task_summary.columns and task_summary[False].sum() > 0:
                task_summary[False].plot(label="Incomplete Tasks", marker='o', linestyle='--', color='r')

            # Customize the chart
            plt.title(f'Task Completion Over Time for Patient {user_id}')
            plt.xlabel('Date')
            plt.ylabel('Number of Tasks')
            plt.legend()

            # Format x-axis as dd MM
            plt.gca().xaxis.set_major_formatter(plt.matplotlib.dates.DateFormatter('%d-%m'))
            plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator())
            plt.gcf().autofmt_xdate()

            # Save the chart as an image in the static directory
            save_path = f'charts/task_summary_{user_id}.png'
            plt.savefig(save_path)
            plt.close()  # Close the plot to avoid memory issues

            return jsonify({"chart_url": save_path})

        else:
            return jsonify({"error": "Failed to fetch tasks"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/users/<user_id>/delay-summary', methods=['GET'])
def get_delay_summary(user_id):
    try:
        tasks_data = get_tasks_for_user(user_id)
        
        if isinstance(tasks_data, list) and tasks_data:
            df = pd.DataFrame(tasks_data)
            if 'completedAt' in df.columns and 'dateTime' in df.columns:
                # Ensure the columns are datetime
                df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
                df['completedAt'] = pd.to_datetime(df['completedAt'], unit='ms', errors='coerce')

                # Calculate delay for completed tasks
                df['delay'] = (df['completedAt'] - df['dateTime']).dt.total_seconds()
                
                # Aggregate delay data
                delay_summary = {
                    "average_delay": df['delay'].mean(),
                    "max_delay": df['delay'].max(),
                    "min_delay": df['delay'].min(),
                    "total_tasks": len(df),
                }

                return jsonify(delay_summary)
            else:
                return jsonify({"error": "Missing 'completedAt' or 'dateTime' in tasks data"}), 400

        return jsonify({"error": "No tasks found for the user"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/users/<user_id>/reminder-schedule', methods=['GET'])
def get_reminder_schedule(user_id):
    try:
        delay_summary = get_delay_summary(user_id).get_json()

        if 'average_delay' in delay_summary:
            avg_delay = delay_summary['average_delay']
            if avg_delay > 3600:  # More than 1 hour
                reminders = 3
            elif avg_delay > 900:  # Between 15 mins and 1 hour
                reminders = 2
            else:  # Less than 15 mins
                reminders = 1
            
            return jsonify({"reminders_per_day": reminders})
        return jsonify({"error": "Failed to fetch delay summary"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/users/<user_id>/delays-chart', methods=['GET'])
def get_delays_chart(user_id):
    try:
        # Fetch tasks for the user
        tasks_data = get_tasks_for_user(user_id)
        
        if isinstance(tasks_data, list):  # Ensure the data is in the correct format
            df = pd.DataFrame(tasks_data)
            if df.empty:
                return jsonify({"error": "No tasks found for the user"}), 404

            if 'delay' not in df.columns:
                return jsonify({"error": "Tasks data is missing the 'delay' field"}), 500

            # Convert delay strings to durations (seconds for simplicity)
            def parse_delay(delay_str):
                if not delay_str or delay_str == 'Completed on time':
                    return 0  # Return 0 for tasks with no delay or completed on time

                time_map = {
                    'day': 86400,  # 24 * 60 * 60
                    'hour': 3600,  # 60 * 60
                    'minute': 60,
                    'second': 1
                }
                total_seconds = 0
                try:
                    for part in delay_str.split(', '):
                        amount, unit = part.split(' ')[:2]
                        total_seconds += int(amount) * time_map[unit.strip()]
                except Exception as e:
                    print(f"Error parsing delay: {e}, delay_str: {delay_str}")
                    return None  # Return None if parsing fails
                return total_seconds
            
            # Apply the parse_delay function
            df['delay_seconds'] = df['delay'].apply(parse_delay)

            # Drop rows with None in delay_seconds
            df = df.dropna(subset=['delay_seconds'])

            if df.empty:
                return jsonify({"error": "No valid delay data found for visualization"}), 404

            # Plot the bar chart
            plt.figure(figsize=(12, 6))
            plt.bar(df['title'], df['delay_seconds'], color='blue', alpha=0.7)
            plt.axhline(y=0, color='green', linestyle='--', label='On-time Tasks')

            # Customize the chart
            plt.title(f'Delay Visualization for Tasks of User {user_id}')
            plt.xlabel('Tasks')
            plt.ylabel('Delay Duration (seconds)')
            plt.xticks(rotation=45, ha='right')
            plt.legend()

            # Save the chart as an image in the static directory
            save_path = f'charts/delay_chart_{user_id}.png'
            plt.tight_layout()
            plt.savefig(save_path)
            plt.close()

            return jsonify({"chart_url": save_path})

        else:
            return jsonify({"error": "Failed to fetch tasks"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/users/<user_id>/visualize-delays', methods=['GET'])
def visualize_delays(user_id):
    try:
        # Fetch tasks for the user
        tasks_data = get_tasks_for_user(user_id)

        if isinstance(tasks_data, list) and tasks_data:
            df = pd.DataFrame(tasks_data)

            # Ensure the necessary columns exist
            if 'completedAt' in df.columns and 'dateTime' in df.columns:
                df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
                df['completedAt'] = pd.to_datetime(df['completedAt'], unit='ms', errors='coerce')

                # Calculate delay (in hours) for completed tasks
                df['delay_hours'] = (df['completedAt'] - df['dateTime']).dt.total_seconds() / 3600
                df = df.dropna(subset=['delay_hours'])

                if df.empty:
                    return jsonify({"error": "No delay data available for the user"}), 404

                # Create interactive chart using Plotly
                fig = px.bar(
                    df,
                    x='title',
                    y='delay_hours',
                    title=f'Task Delays for User {user_id}',
                    labels={"title": "Task", "delay_hours": "Delay (hours)"},
                    color='delay_hours',
                    color_continuous_scale='Viridis'
                )
                fig.update_layout(
                    xaxis_tickangle=-45,
                    xaxis_title="Task Title",
                    yaxis_title="Delay Duration (hours)",
                    coloraxis_colorbar=dict(title="Delay (hours)")
                )

                # Convert the chart to JSON format
                graph_json = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)
                return jsonify({"chart": graph_json})

            return jsonify({"error": "Required fields 'completedAt' and 'dateTime' are missing"}), 400

        return jsonify({"error": "No tasks found for the user"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# # Utility function to calculate delay in minutes
# def calculate_delay(task):
#     if task.get('completedAt') and task.get('dateTime'):
#         print(f"Raw completedAt: {task['completedAt']}, dateTime: {task['dateTime']}")
#         try:
#             # Convert Firestore timestamps to datetime objects
#             scheduled_time = datetime.fromtimestamp(task['dateTime'] /1000)
#             completed_time = datetime.fromtimestamp(task['completedAt'] /1000)
#         except ValueError as e:
#             print(f"Invalid timestamp in task: {task}. Error: {e}")
#             return None    
        
#         delay = (completed_time - scheduled_time).total_seconds() / 60  # in minutes
#         return delay
#     return None

# @app.route('/users/<string:user_id>/forecast', methods=['GET'])
# def forecast_delays(user_id):
#     try:
#         # Fetch tasks for the user
#         user_ref = db.collection('users').document(user_id)
#         tasks_ref = user_ref.collection('tasks')
#         tasks = tasks_ref.stream()

#         delays = []
#         for task in tasks:
#             task_data = task.to_dict()
#             delay = calculate_delay(task_data)
#             if delay is not None:
#                 delays.append(delay)

#         # If there are delays, build the ARIMA model
#         if len(delays) > 1:
#             df = pd.DataFrame(delays, columns=["delay"])

#             # Fit ARIMA model (with order (p=1, d=1, q=1) - adjust parameters as needed)
#             model = ARIMA(df["delay"], order=(1, 1, 1))
#             model_fit = model.fit()

#             # Forecast future delays (next 7 days for example)
#             forecast_steps = 7
#             forecast = model_fit.forecast(steps=forecast_steps)

#             # Return forecasted delays
#             forecast_data = [{"day": i+1, "forecasted_delay": forecast[i]} for i in range(forecast_steps)]
#             return jsonify(forecast_data)

#         else:
#             return jsonify({"error": "Not enough data for forecasting."}), 400

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

# Utility function to calculate delay in minutes
# def calculate_delay(task):
    
#     if task.get('completedAt') and task.get('dateTime'):
#         print(f"Raw completedAt: {task['completedAt']}, dateTime: {task['dateTime']}")
#         try:
#             # Convert Firestore timestamps to datetime objects
#             scheduled_time = datetime.fromtimestamp(task['dateTime'] / 1000)
#             completed_time = datetime.fromtimestamp(task['completedAt'] / 1000)
#         except ValueError as e:
#             print(f"Invalid timestamp in task: {task}. Error: {e}")
#             return None
        
#         delay = (completed_time - scheduled_time).total_seconds() / 60  # in minutes
#         return delay
#     return None

# @app.route('/users/<string:user_id>/forecast', methods=['GET'])
# def forecast_delays(user_id):
#     try:
#         # Fetch tasks for the user
#         user_ref = db.collection('users').document(user_id)
#         tasks_ref = user_ref.collection('tasks')
#         tasks = tasks_ref.stream()

#         delays = []
#         for task in tasks:
#             task_data = task.to_dict()
#             delay = calculate_delay(task_data)
#             if delay is not None:
#                 delays.append(delay)

#         # If there are delays, build the ARIMA model
#         if len(delays) > 1:
#             df = pd.DataFrame(delays, columns=["delay"])

#             print("Delays:", delays)

#             # Fit ARIMA model (with order (p=1, d=1, q=1) - adjust parameters as needed)
#             model = ARIMA(df["delay"], order=(1, 1, 1))
#             model_fit = model.fit()

#             print("Forecast output:", forecast)

#             # Forecast future delays (next 7 days for example)
#             forecast_steps = 7
#             forecast = model_fit.forecast(steps=forecast_steps)

#             # # Ensure forecast output is iterable
#             # forecast = forecast.tolist()  # Convert to a Python list if needed

#             # # Return forecasted delays
#             # forecast_data = [{"day": i + 1, "forecasted_delay": float(forecast[i])} for i in range(forecast_steps)]
#             # return jsonify(forecast_data)

#             # Ensure forecast is iterable
#             if not hasattr(forecast, "__iter__"):
#                 forecast = [forecast] * forecast_steps

#             # Build forecast data
#             forecast_data = [
#                 {"day": i + 1, "forecasted_delay": float(forecast[i])}
#                 for i in range(len(forecast))
#             ]
#             return jsonify(forecast_data)

#         else:
#             return jsonify({"error": "Not enough data for forecasting."}), 400

#     except Exception as e:
#         print(f"Error in forecast_delays: {e}")
#         return jsonify({"error": str(e)}), 500

"""
my codeee
@app.route('/users/<string:user_id>/forecast', methods=['GET'])
def forecast_delays(user_id):
    try:
        # Fetch tasks for the user
        user_ref = db.collection('users').document(user_id)
        tasks_ref = user_ref.collection('tasks')
        tasks = tasks_ref.stream()

        delays = []
        for task in tasks:
            task_data = task.to_dict()
            delay = calculate_delay(task_data)
            if delay is not None:
                delays.append(delay)

        # If there are delays, attempt forecasting
        if len(delays) > 1:
            df = pd.DataFrame(delays, columns=["delay"])
            print("Delays:", delays)

            try:
                # Use a more robust approach for small datasets
                if len(delays) < 5:
                    # Simple forecasting for very small datasets
                    mean_delay = df['delay'].mean()
                    forecast_data = [
                        {"day": i + 1, "forecasted_delay": mean_delay}
                        for i in range(7)
                    ]
                else:
                    # Attempt ARIMA for larger datasets
                    model = ARIMA(df["delay"], order=(1, 1, 1))
                    model_fit = model.fit()

                    # Forecast future delays
                    forecast_steps = 7
                    forecast = model_fit.get_forecast(steps=forecast_steps)
                    predicted_mean = forecast.predicted_mean

                    forecast_data = [
                        {"day": i + 1, "forecasted_delay": float(predicted_mean[i])}
                        for i in range(len(predicted_mean))
                    ]

                return jsonify(forecast_data)

            except Exception as model_error:
                print(f"Forecasting model error: {model_error}")
                # Fallback to simple mean-based forecast
                mean_delay = df['delay'].mean()
                forecast_data = [
                    {"day": i + 1, "forecasted_delay": mean_delay}
                    for i in range(7)
                ]
                return jsonify(forecast_data)

        else:
            return jsonify({"error": "Not enough data for forecasting."}), 400

    except Exception as e:
        print(f"Error in forecast_delays: {e}")
        return jsonify({"error": str(e)}), 500


@app.route('/users/<user_id>/caregiver-insights', methods=['GET'])
def caregiver_insights(user_id):
    try:
        # Fetch all tasks for the user
        tasks_data = get_tasks_for_user(user_id)
        
        if isinstance(tasks_data, list) and tasks_data:
            df = pd.DataFrame(tasks_data)
            
            # Ensure necessary columns exist and convert timestamps
            if 'dateTime' not in df.columns or 'isDone' not in df.columns:
                return jsonify({"error": "Missing required columns"}), 400
            
            # Convert timestamps
            df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
            df['completedAt'] = pd.to_datetime(df['completedAt'], unit='ms', errors='coerce')

            
            # Insights for caregivers
            insights = {}
            
            # Task Completion Insights
            total_tasks = len(df)
            completed_tasks = df[df['isDone'] == True]
            incomplete_tasks = df[df['isDone'] == False]
            
            insights['total_tasks'] = total_tasks
            insights['completed_tasks'] = len(completed_tasks)
            insights['incomplete_tasks'] = len(incomplete_tasks)
            insights['completion_rate'] = round((len(completed_tasks) / total_tasks) * 100, 2) if total_tasks > 0 else 0
            
            # Average completion time for completed tasks
            if 'completedAt' in df.columns:
                df['completedAt'] = pd.to_datetime(df['completedAt'], unit='ms', errors='coerce')
                completed_tasks = completed_tasks.dropna(subset=['completedAt', 'dateTime'])
                completed_tasks['completion_time'] = (completed_tasks['completedAt'] - completed_tasks['dateTime']).dt.total_seconds() / 60
                insights['average_completion_time_minutes'] = round(completed_tasks['completion_time'].mean(), 2) if not completed_tasks.empty else None
            
            # High-priority pending tasks
            if 'priority' in df.columns:
                high_priority_pending = incomplete_tasks[incomplete_tasks['priority'] == 'high']
                insights['high_priority_pending'] = len(high_priority_pending)
            
            # Task Completion Trend
            recent_tasks = df.sort_values('dateTime', ascending=False).head(5)
            insights['recent_task_performance'] = {
                'completed': len(recent_tasks[recent_tasks['isDone'] == True]),
                'incomplete': len(recent_tasks[recent_tasks['isDone'] == False])
            }
            
            # Recommendations
            insights['recommendations'] = []
            if insights['completion_rate'] < 70:
                insights['recommendations'].append("Encourage the patient to stay on schedule.")
            if insights.get('high_priority_pending', 0) > 0:
                insights['recommendations'].append("Focus on high-priority tasks.")
            
            return jsonify(insights)

        return jsonify({"error": "No tasks found for the user"}), 404

    except Exception as e:
        print(f"Error in caregiver_insights: {e}")
        return jsonify({"error": str(e)}), 500
"""


#calculate the delay for each task
# def calculate_delay(task_data):
#     if 'dateTime' in task_data and 'completedAt' in task_data and task_data['completedAt']:
#         try:
#             # Convert timestamps to datetime objects
#             scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
#             completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
#             # Calculate delay in minutes
#             delay = (completed_time - scheduled_time).total_seconds() / 60  # Delay in minutes
#             print(f"Calculated Delay: {delay}")  # Log calculated delay
#             return delay
#         except Exception as e:
#             print(f"Error calculating delay: {e}")       
#     else:
#         print("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
#     return None

# Group tasks by day and calculate the average delay for each day
# def calculate_daily_delays(tasks):
#     daily_delays = {}
#     for task in tasks:
#         task_data = task.to_dict()
#         delay = calculate_delay(task_data)
#         if delay is not None:
#             day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
#             day_str = day.isoformat()  # Convert date to string
#             if day_str in daily_delays:
#                 daily_delays[day_str].append(delay)
#             else:
#                 daily_delays[day_str] = [delay]
    
#     # Calculate average delay per day
#     average_daily_delays = {day: sum(delays) / len(delays) for day, delays in daily_delays.items()}
#     return average_daily_delays

# def calculate_daily_delays(tasks):
#     daily_delays = {}
#     for task in tasks:
#         task_data = task.to_dict()
#         print(f"Task Data: {task_data}")  # Log task data

#         # Calculate delay for the task
#         delay = calculate_delay(task_data)
#         print(f"Delay: {delay}")  # Log calculated delay

#         if delay is not None:
#             # Ensure the 'dateTime' field exists and is in the correct format
#             if 'dateTime' in task_data:
#                 try:
#                     # Convert timestamp to date
#                     day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
#                     day_str = day.isoformat()  # Convert date to string
#                     print(f"Day: {day_str}")  # Log the day

#                     # Add delay to the corresponding day
#                     if day_str in daily_delays:
#                         daily_delays[day_str].append(delay)
#                     else:
#                         daily_delays[day_str] = [delay]
#                 except Exception as e:
#                     print(f"Error processing task dateTime: {e}")
#             else:
#                 print("Task is missing 'dateTime' field.")
#         else:
#             print("Delay is None for this task.")
    
#     # Log grouped delays
#     print(f"Daily Delays: {daily_delays}")

#     # Calculate average delay per day
#     average_daily_delays = {day: sum(delays) / len(delays) for day, delays in daily_delays.items()}
#     print(f"Average Daily Delays: {average_daily_delays}")  # Log average daily delays

#     return average_daily_delays# Determine if the delay is increasing or decreasing over time

# def calculate_daily_delays(tasks):
#     daily_delays = {}
#     for task in tasks:
#         task_data = task.to_dict()
#         print(f"Task Data: {task_data}")  # Log task data

#         # Ensure the 'dateTime' field exists
#         if 'dateTime' in task_data:
#             print(f"dateTime: {task_data['dateTime']}")  # Log dateTime value
#         else:
#             print("Task is missing 'dateTime' field.")
#             continue  # Skip this task if 'dateTime' is missing

#         # Calculate delay for the task
#         delay = calculate_delay(task_data)
#         print(f"Delay: {delay}")  # Log calculated delay

#         if delay is not None:
#             try:
#                 # Convert timestamp to date
#                 day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
#                 day_str = day.isoformat()  # Convert date to string
#                 print(f"Day: {day_str}")  # Log the day

#                 # Add delay to the corresponding day
#                 if day_str in daily_delays:
#                     daily_delays[day_str].append(delay)
#                 else:
#                     daily_delays[day_str] = [delay]
#             except Exception as e:
#                 print(f"Error processing task dateTime: {e}")
#         else:
#             print("Delay is None for this task.")
    
#     # Log grouped delays
#     print(f"Daily Delays: {daily_delays}")

#     # Calculate average delay per day
#     average_daily_delays = {day: sum(delays) / len(delays) for day, delays in daily_delays.items()}
#     print(f"Average Daily Delays: {average_daily_delays}")  # Log average daily delays

#     return average_daily_delays

# def calculate_daily_delays(tasks):
#     daily_delays = {}
#     for task in tasks:
#         task_data = task.to_dict()
#         print(f"Task Data: {task_data}")  # Log task data

#         # Ensure the 'dateTime' and 'completedAt' fields exist
#         if 'dateTime' in task_data:
#             print(f"dateTime: {task_data['dateTime']}")  # Log dateTime value
#         else:
#             print("Task is missing 'dateTime' field.")
#             continue  # Skip this task if 'dateTime' is missing

#         if 'completedAt' in task_data:
#             print(f"completedAt: {task_data['completedAt']}")  # Log completedAt value
#         else:
#             print("Task is missing 'completedAt' field.")
#             continue  # Skip this task if 'completedAt' is missing

#         # Calculate delay for the task
#         delay = calculate_delay(task_data)
#         print(f"Delay: {delay}")  # Log calculated delay

#         if delay is not None:
#             try:
#                 # Convert timestamp to date
#                 day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
#                 day_str = day.isoformat()  # Convert date to string
#                 print(f"Day: {day_str}")  # Log the day

#                 # Add delay to the corresponding day
#                 if day_str in daily_delays:
#                     daily_delays[day_str].append(delay)
#                 else:
#                     daily_delays[day_str] = [delay]
#             except Exception as e:
#                 print(f"Error processing task dateTime: {e}")
#         else:
#             print("Delay is None for this task.")
    
#     # Log grouped delays
#     print(f"Daily Delays: {daily_delays}")

#     # Calculate average delay per day
#     average_daily_delays = {day: sum(delays) / len(delays) for day, delays in daily_delays.items()}
#     print(f"Average Daily Delays: {average_daily_delays}")  # Log average daily delays

#     return average_daily_delays

# def calculate_daily_delays(tasks):
#     daily_delays = {}
#     for task in tasks:
#         task_data = task.to_dict()
#         print(f"Task Data: {task_data}")  # Log task data

#         # Ensure the 'dateTime' and 'completedAt' fields exist
#         if 'dateTime' in task_data:
#             print(f"dateTime: {task_data['dateTime']}")  # Log dateTime value
#         else:
#             print("Task is missing 'dateTime' field.")
#             continue  # Skip this task if 'dateTime' is missing

#         if 'completedAt' in task_data:
#             print(f"completedAt: {task_data['completedAt']}")  # Log completedAt value
#         else:
#             print("Task is missing 'completedAt' field.")
#             continue  # Skip this task if 'completedAt' is missing

#         # Calculate delay for the task
#         delay = calculate_delay(task_data)
#         print(f"Delay: {delay}")  # Log calculated delay

#         if delay is not None:
#             try:
#                 # Convert timestamp to date
#                 day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
#                 day_str = day.isoformat()  # Convert date to string
#                 print(f"Day: {day_str}")  # Log the day

#                 # Add delay to the corresponding day
#                 if day_str in daily_delays:
#                     daily_delays[day_str].append(delay)
#                 else:
#                     daily_delays[day_str] = [delay]
#             except Exception as e:
#                 print(f"Error processing task dateTime: {e}")
#         else:
#             print("Delay is None for this task.")
    
#     # Log grouped delays
#     print(f"Daily Delays: {daily_delays}")

#     # Calculate average delay per day
#     average_daily_delays = {day: sum(delays) / len(delays) for day, delays in daily_delays.items()}
#     print(f"Average Daily Delays: {average_daily_delays}")  # Log average daily delays

#     return average_daily_delays

# def calculate_daily_delays(tasks):
#     daily_delays = {}
#     for task in tasks:
#         task_data = task.to_dict()
#         print(f"Task Data: {task_data}")  # Log task data

#         # Ensure the 'dateTime' and 'completedAt' fields exist
#         if 'dateTime' in task_data:
#             print(f"dateTime: {task_data['dateTime']}")  # Log dateTime value
#         else:
#             print("Task is missing 'dateTime' field.")
#             continue  # Skip this task if 'dateTime' is missing

#         if 'completedAt' in task_data:
#             print(f"completedAt: {task_data['completedAt']}")  # Log completedAt value
#         else:
#             print("Task is missing 'completedAt' field.")
#             continue  # Skip this task if 'completedAt' is missing

#         # Calculate delay for the task
#         delay = calculate_delay(task_data)
#         print(f"Delay: {delay}")  # Log calculated delay

#         if delay is not None:
#             try:
#                 # Convert timestamp to date
#                 day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
#                 day_str = day.isoformat()  # Convert date to string
#                 print(f"Day: {day_str}")  # Log the day

#                 # Add delay to the corresponding day
#                 if day_str in daily_delays:
#                     daily_delays[day_str].append(delay)
#                 else:
#                     daily_delays[day_str] = [delay]
#             except Exception as e:
#                 print(f"Error processing task dateTime: {e}")
#         else:
#             print("Delay is None for this task.")
    
#     # Log grouped delays
#     print(f"Daily Delays: {daily_delays}")

#     # Calculate average delay per day
#     average_daily_delays = {day: sum(delays) / len(delays) for day, delays in daily_delays.items()}
#     print(f"Average Daily Delays: {average_daily_delays}")  # Log average daily delays

#     return average_daily_delays

def calculate_daily_delays(tasks):
    daily_delays = {}
    for task in tasks:
        task_data = task.to_dict()
        print(f"Task Data: {task_data}")  # Log task data

        # Ensure the 'dateTime' and 'completedAt' fields exist
        if 'dateTime' in task_data:
            print(f"dateTime: {task_data['dateTime']}")  # Log dateTime value
        else:
            print("Task is missing 'dateTime' field.")
            continue  # Skip this task if 'dateTime' is missing

        if 'completedAt' in task_data:
            print(f"completedAt: {task_data['completedAt']}")  # Log completedAt value
        else:
            print("Task is missing 'completedAt' field.")
            continue  # Skip this task if 'completedAt' is missing

        # Calculate delay for the task
        delay = calculate_delay(task_data)
        print(f"Delay: {delay}")  # Log calculated delay

        if delay is not None:
            try:
                # Convert timestamp to date
                day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
                day_str = day.isoformat()  # Convert date to string
                print(f"Day: {day_str}")  # Log the day

                # Add delay to the corresponding day
                if day_str in daily_delays:
                    daily_delays[day_str].append(delay)
                else:
                    daily_delays[day_str] = [delay]
            except Exception as e:
                print(f"Error processing task dateTime: {e}")
        else:
            print("Delay is None for this task.")
    
    # Log grouped delays
    print(f"Daily Delays: {daily_delays}")

    # Calculate average delay per day
    average_daily_delays = {day: sum(delays) / len(delays) for day, delays in daily_delays.items()}
    print(f"Average Daily Delays: {average_daily_delays}")  # Log average daily delays

    return average_daily_delays

def analyze_delay_trend(average_daily_delays):
    days = sorted(average_daily_delays.keys())
    delays = [average_daily_delays[day] for day in days]
    
    if len(delays) < 2:
        return "Not enough data to determine trend."
    
    # Calculate the trend (slope of the line)
    from scipy.stats import linregress
    slope, _, _, _, _ = linregress(range(len(delays)), delays)
    
    if slope > 0:
        print("Delay is increasing over time.")
        return "Delay is increasing over time."
    elif slope < 0:
        print("Delay is decreasing over time.")
        return "Delay is decreasing over time."
    else:
        print("Delay is stable over time.")
        return "Delay is stable over time."

# Based on the trend, adjust the frequency of reminders
def adjust_reminders(trend):
    if trend == "Delay is increasing over time.":
        return "Increase the frequency of reminders."
    elif trend == "Delay is decreasing over time.":
        return "Decrease the frequency of reminders."
    else:
        return "Maintain the current frequency of reminders."

@app.route('/users/<string:user_id>/forecast', methods=['GET'])
def forecast_delays(user_id):
    try:
        # Fetch tasks for the user
        user_ref = db.collection('users').document(user_id)
        tasks_ref = user_ref.collection('tasks')
        tasks = tasks_ref.stream()

        tasks_list = list(tasks)  # Convert iterator to list
        print(f"Number of tasks: {len(tasks_list)}")  # Log the number of tasks

        # Log task IDs
        for task in tasks_list:
            print(f"Task ID: {task.id}")  # Log task IDs

        # Reset the iterator
        tasks = iter(tasks_list)

        delays = []
        total_tasks = 0
        completed_tasks = 0
        incomplete_tasks = 0
        delayed_tasks = 0

        for task in tasks:
            task_data = task.to_dict()
            total_tasks += 1
            if task_data.get('isDone', False):
                completed_tasks += 1
                delay = calculate_delay(task_data)
                if delay is not None and delay > 0:
                    delayed_tasks += 1
                    delays.append(delay)
            else:
                incomplete_tasks += 1

        print("Calling calculate_daily_delays...")  # Log before calling the function
        # Calculate average daily delays
        average_daily_delays = calculate_daily_delays(tasks)
        print(f"Average Daily Delays: {average_daily_delays}")  # Log average daily delays
        
        # Analyze delay trend
        trend = analyze_delay_trend(average_daily_delays)
        
        # Adjust reminders based on trend
        reminder_adjustment = adjust_reminders(trend)

        # Generate forecast_data for the next 7 days
        forecast_data = []
        if delays:
            # Use linear regression to forecast delays
            x = np.arange(len(delays))
            y = np.array(delays)
            slope, intercept, _, _, _ = linregress(x, y)

            # Forecast delays for the next 7 days
            for day in range(1, 8):
                forecasted_delay = intercept + slope * (len(delays) + day - 1)
                forecast_data.append({
                    "day": day,
                    "forecasted_delay": forecasted_delay
                })
        else:
            # If no delays, return default values
            for day in range(1, 8):
                forecast_data.append({
                    "day": day,
                    "forecasted_delay": 0.0
                })
        
        # Prepare response
        response = {
            "forecast_data": forecast_data, 
            "average_daily_delays": average_daily_delays,
            "trend": trend,
            "reminder_adjustment": reminder_adjustment,
            "total_tasks": total_tasks,
            "completed_tasks": completed_tasks,
            "incomplete_tasks": incomplete_tasks,
            "delayed_tasks": delayed_tasks
        }
        
        return jsonify(response)

    except Exception as e:
        print(f"Error in forecast_delays: {e}")
        return jsonify({"error": str(e)}), 500








############222

# def calculate_delay(task_data):
#     """
#     Calculate the delay between the scheduled time and the completion time.
#     Returns the delay in minutes.
#     """
#     if 'dateTime' in task_data and 'completedAt' in task_data and task_data['completedAt']:
#         try:
#             # Convert timestamps to datetime objects
#             scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
#             completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
#             # Calculate delay in minutes
#             delay = (completed_time - scheduled_time).total_seconds() / 60  # Delay in minutes
#             print(f"Calculated Delay: {delay}")  # Log calculated delay
#             return delay
#         except Exception as e:
#             print(f"Error calculating delay: {e}")
#     else:
#         print("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
#     return None

# def generate_scatter_plot(delayed_tasks):
#     """
#     Generate a time series chart of task delays over time.
#     """
#     # Convert tasks data to a DataFrame
#     df = pd.DataFrame(delayed_tasks)
    
#     # Convert timestamp to datetime
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
#     df['date'] = df['dateTime'].dt.date

#     # Aggregate delays by date
#     task_summary = df.groupby('date')['delay'].sum().reset_index()

#     # Plotting the time series chart
#     plt.figure(figsize=(10, 6))

#     # Plot delays over time
#     plt.plot(task_summary['date'], task_summary['delay'], label="Task Delays", marker='o', linestyle='-', color='b')

#     # Customize the chart
#     plt.title('Task Delays Over Time')
#     plt.xlabel('Date')
#     plt.ylabel('Delay (minutes)')
#     plt.legend()

#     # Format x-axis as dd-MM
#     plt.gca().xaxis.set_major_formatter(plt.matplotlib.dates.DateFormatter('%d-%m'))
#     plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator())
#     plt.gcf().autofmt_xdate()

#     # Save the plot to a BytesIO object
#     buf = io.BytesIO()
#     plt.savefig(buf, format='png')
#     buf.seek(0)
#     plt.close()

#     # Encode the plot as a base64 string
#     plot_data = base64.b64encode(buf.read()).decode('utf-8')
#     return plot_data

# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             return jsonify({"error": "No tasks found for the user"}), 404

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
        
#         # Filter completed tasks
#         completed_tasks = df[df['isDone'] == True]
#         incomplete_tasks = df[df['isDone'] == False]

#         # Calculate delays for completed tasks
#         completed_tasks['delay'] = completed_tasks.apply(calculate_delay, axis=1)
#         delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0

#         # Most frequently delayed tasks
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict()

#         # Time of day analysis
#         delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#         time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()

#         # Generate scatter plot
#         scatter_plot = generate_scatter_plot(delayed_tasks.to_dict('records'))

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(completed_tasks),
#             'delayed_tasks': len(delayed_tasks),
#             'incomplete_tasks': len(incomplete_tasks),
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot': scatter_plot,  # Include the scatter plot as a base64 string
#             'timestamp': datetime.now().isoformat()
#         }

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)

#         # Return the analysis data and scatter plot as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500


############333


#1
# def calculate_delay(task_data):
#     """
#     Calculate the delay between the scheduled time and the completion time.
#     Returns the delay in minutes.
#     """
#     if 'dateTime' in task_data and 'completedAt' in task_data and task_data['completedAt']:
#         try:
#             # Convert timestamps to datetime objects
#             scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
#             completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
#             # Calculate delay in minutes
#             delay = (completed_time - scheduled_time).total_seconds() / 60  # Delay in minutes
#             print(f"Calculated Delay: {delay}")  # Log calculated delay
#             return delay
#         except Exception as e:
#             print(f"Error calculating delay: {e}")
#     else:
#         print("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
#     return None
#2
# def calculate_delay(task_data):
#     """
#     Calculate the delay between the scheduled time and the completion time.
#     Returns the delay in minutes.
#     """
#     # Check if required fields exist and are not null
#     if 'dateTime' not in task_data or 'completedAt' not in task_data or not task_data['completedAt']:
#         print("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
#         return None

#     try:
#         # Convert timestamps to datetime objects
#         scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
#         completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')

#         # Calculate delay in minutes
#         delay = (completed_time - scheduled_time).total_seconds() / 60  # Delay in minutes
#         print(f"Calculated Delay: {delay}")  # Log calculated delay
#         return delay
#     except Exception as e:
#         print(f"Error calculating delay: {e}")
#         return None

#2
# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             return jsonify({"error": "No tasks found for the user"}), 404

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
        
#         # Filter completed tasks (only tasks with isDone == True)
#         completed_tasks = df[df['isDone'] == True].copy()

#         # Calculate delays for completed tasks
#         completed_tasks.loc[:, 'delay'] = completed_tasks.apply(calculate_delay, axis=1)

#         # Drop rows where delay is NaN (incomplete or invalid tasks)
#         completed_tasks = completed_tasks.dropna(subset=['delay'])

#         # Filter delayed tasks (delay > 0)
#         delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0

#         # Most frequently delayed tasks
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict()

#         # Time of day analysis
#         delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#         time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()

#         # Generate scatter plot
#         scatter_plot = generate_scatter_plot(delayed_tasks.to_dict('records'))

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(completed_tasks),
#             'delayed_tasks': len(delayed_tasks),
#             'incomplete_tasks': len(df[df['isDone'] == False]),  # Count incomplete tasks
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot': scatter_plot,  # Include the scatter plot as a base64 string
#             'timestamp': datetime.now().isoformat()
#         }

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)

#         # Return the analysis data and scatter plot as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500 

#1    
# def generate_scatter_plot(delayed_tasks):
#     """
#     Generate a time series chart of task delays over time.
#     """
#     # Convert tasks data to a DataFrame
#     df = pd.DataFrame(delayed_tasks)
    
#     # Convert timestamp to datetime
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
#     df['date'] = df['dateTime'].dt.date

#     # Aggregate delays by date
#     task_summary = df.groupby('date')['delay'].sum().reset_index()

#     # Plotting the time series chart
#     plt.figure(figsize=(10, 6))

#     # Plot delays over time
#     plt.plot(task_summary['date'], task_summary['delay'], label="Task Delays", marker='o', linestyle='-', color='b')

#     # Customize the chart
#     plt.title('Task Delays Over Time')
#     plt.xlabel('Date')
#     plt.ylabel('Delay (minutes)')
#     plt.legend()

#     # Format x-axis as dd-MM
#     plt.gca().xaxis.set_major_formatter(plt.matplotlib.dates.DateFormatter('%d-%m'))
#     plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator())
#     plt.gcf().autofmt_xdate()

#     # Save the plot to a BytesIO object
#     buf = io.BytesIO()
#     plt.savefig(buf, format='png')
#     buf.seek(0)
#     plt.close()

#     # Encode the plot as a base64 string
#     plot_data = base64.b64encode(buf.read()).decode('utf-8')
#     return plot_data

#1
# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             return jsonify({"error": "No tasks found for the user"}), 404

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
        
#         # Filter completed tasks
#         completed_tasks = df[df['isDone'] == True].copy()
#         incomplete_tasks = df[df['isDone'] == False]

#         # Calculate delays for completed tasks
#         completed_tasks.loc[:, 'delay'] = completed_tasks.apply(calculate_delay, axis=1)

#         # Convert the 'delay' column to numeric, handling errors by setting invalid values to NaN
#         completed_tasks['delay'] = pd.to_numeric(completed_tasks['delay'], errors='coerce')

#         # Drop rows with NaN values in the 'delay' column (optional: you can also fill NaN with 0)
#         completed_tasks = completed_tasks.dropna(subset=['delay'])

#         # Filter delayed tasks (delay > 0)
#         delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0

#         # Most frequently delayed tasks
#         # Ensure the 'delay' column is numeric before using nlargest
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict()

#         # Time of day analysis
#         delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#         time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()

#         # Generate scatter plot
#         scatter_plot = generate_scatter_plot(delayed_tasks.to_dict('records'))

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(completed_tasks),
#             'delayed_tasks': len(delayed_tasks),
#             'incomplete_tasks': len(incomplete_tasks),
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot': scatter_plot,  # Include the scatter plot as a base64 string
#             'timestamp': datetime.now().isoformat()
#         }

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)

#         # Return the analysis data and scatter plot as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500


@app.route('/users/<string:user_id>/tasks', methods=['GET'])
def get_tasks_for_user(user_id):
    try:
        user_ref = db.collection('users').document(user_id)
        tasks_ref = user_ref.collection('tasks')
        tasks = tasks_ref.stream()

        tasks_list = []
        for task in tasks:
            task_data = task.to_dict()
            task_data['id'] = task.id  # Include task ID
            tasks_list.append(task_data)

        return tasks_list  # Return the list of tasks directly, not a Flask response
    except Exception as e:
        return jsonify({"error": str(e)}), 500

#3
# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             return jsonify({"error": "No tasks found for the user"}), 404

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
        
#         # Filter completed tasks (only tasks with isDone == True)
#         completed_tasks = df[df['isDone'] == True].copy()

#         # Calculate delays for completed tasks
#         completed_tasks.loc[:, 'delay'] = completed_tasks.apply(calculate_delay, axis=1)

#         # Convert the 'delay' column to numeric, handling errors by setting invalid values to NaN
#         completed_tasks['delay'] = pd.to_numeric(completed_tasks['delay'], errors='coerce')

#         # Drop rows with NaN values in the 'delay' column (optional: you can also fill NaN with 0)
#         completed_tasks = completed_tasks.dropna(subset=['delay'])

#         # Filter delayed tasks (delay > 0)
#         delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0

#         # Most frequently delayed tasks
#         # Ensure the 'delay' column is numeric before using nlargest
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict()

#         # Time of day analysis
#         delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#         time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()

#         # Generate scatter plot
#         scatter_plot = generate_scatter_plot(delayed_tasks.to_dict('records'))

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(completed_tasks),
#             'delayed_tasks': len(delayed_tasks),
#             'incomplete_tasks': len(df[df['isDone'] == False]),  # Count incomplete tasks
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot': scatter_plot,  # Include the scatter plot as a base64 string
#             'timestamp': datetime.now().isoformat()
#         }

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)

#         # Return the analysis data and scatter plot as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

#4




###9***
# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             return jsonify({"error": "No tasks found for the user"}), 404

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
        
#         # Filter completed tasks (only tasks with isDone == True and completedAt is not null)
#         completed_tasks = df[(df['isDone'] == True) & (df['completedAt'].notnull())].copy()

#         # Calculate delays for completed tasks
#         completed_tasks.loc[:, 'delay'] = completed_tasks.apply(calculate_delay, axis=1)

#         # Convert the 'delay' column to numeric, handling errors by setting invalid values to NaN
#         completed_tasks['delay'] = pd.to_numeric(completed_tasks['delay'], errors='coerce')

#         # Drop rows with NaN values in the 'delay' column (optional: you can also fill NaN with 0)
#         completed_tasks = completed_tasks.dropna(subset=['delay'])

#         # Filter delayed tasks (delay > 0)
#         delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0

#         # Most frequently delayed tasks
#         # Ensure the 'delay' column is numeric before using nlargest
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict()

#         # Time of day analysis
#         delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#         time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()

#         # Generate scatter plot
#         scatter_plot_path = generate_scatter_plot(delayed_tasks.to_dict('records'), user_id)

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(completed_tasks),
#             'delayed_tasks': len(delayed_tasks),
#             'incomplete_tasks': len(df[df['isDone'] == False]),  # Count incomplete tasks
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot_path': scatter_plot_path,  # Path to the saved scatter plot image
#             'timestamp': datetime.now().isoformat()
#         }

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)

#         # Return the analysis data and scatter plot path as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

# def calculate_delay(task_data):
#     """
#     Calculate the delay between the scheduled time and the completion time.
#     Returns the delay in minutes.
#     """
#     # Check if required fields exist and are not null
#     if 'dateTime' not in task_data or 'completedAt' not in task_data or not task_data['completedAt']:
#         print("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
#         return None

#     try:
#         # Convert timestamps to datetime objects
#         scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
#         completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')

#         # Calculate delay in minutes
#         delay = (completed_time - scheduled_time).total_seconds() / 60  # Delay in minutes
#         print(f"Calculated Delay: {delay}")  # Log calculated delay
#         return delay
#     except Exception as e:
#         print(f"Error calculating delay: {e}")
#         return None

####
# def generate_scatter_plot(delayed_tasks, user_id):
#     """
#     Generate a scatter plot of task delays over time and save it as an image file.
#     Returns the path to the saved image file.
#     """
#     # Convert tasks data to a DataFrame
#     df = pd.DataFrame(delayed_tasks)
    
#     # Convert timestamp to datetime
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
#     df['date'] = df['dateTime'].dt.date

#     # Aggregate delays by date
#     task_summary = df.groupby('date')['delay'].sum().reset_index()

#     # Plotting the scatter plot
#     plt.figure(figsize=(10, 6))

#     # Plot delays over time
#     plt.scatter(task_summary['date'], task_summary['delay'], label="Task Delays", color='b')

#     # Customize the chart
#     plt.title('Task Delays Over Time')
#     plt.xlabel('Date')
#     plt.ylabel('Delay (minutes)')
#     plt.legend()

#     # Format x-axis as dd-MM
#     plt.gca().xaxis.set_major_formatter(plt.matplotlib.dates.DateFormatter('%d-%m'))
#     plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator())
#     plt.gcf().autofmt_xdate()

#     # Save the plot to the 'charts' folder
#     save_path = f'charts/scatter_plot_{user_id}.png'
#     plt.savefig(save_path)
#     plt.close()  # Close the plot to avoid memory issues

#     return save_path

#10
# def generate_scatter_plot(delayed_tasks, user_id):
#     """
#     Generate a scatter plot of task delays over time with a trend line and date labels.
#     Returns the path to the saved image file.
#     """
#     # Convert tasks data to a DataFrame
#     df = pd.DataFrame(delayed_tasks)
    
#     # Convert timestamp to datetime
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
#     df['date'] = df['dateTime'].dt.date

#     # Aggregate delays by date
#     task_summary = df.groupby('date')['delay'].sum().reset_index()

#     # Plotting the scatter plot
#     plt.figure(figsize=(12, 6))

#     # Plot delays over time as a scatter plot
#     plt.scatter(task_summary['date'], task_summary['delay'], label="Task Delays", color='b')

#     # Add a trend line to show the overall trend
#     plt.plot(task_summary['date'], task_summary['delay'], linestyle='-', color='r', label="Trend Line")

#     # Add date labels under the dots (only for dates with values)
#     for i, row in task_summary.iterrows():
#         plt.text(row['date'], row['delay'] - 5, row['date'].strftime('%d-%m'), 
#                  fontsize=8, ha='center', va='top', rotation=45)

#     # Customize the chart
#     plt.title('Task Delays Over Time')
#     plt.xlabel('Date')
#     plt.ylabel('Delay (minutes)')
#     plt.legend()

#     # Format x-axis as dd-MM
#     plt.gca().xaxis.set_major_formatter(plt.matplotlib.dates.DateFormatter('%d-%m'))
#     plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator())
#     plt.gcf().autofmt_xdate()

#     # Save the plot to the 'charts' folder
#     save_path = f'charts/scatter_plot_{user_id}.png'
#     plt.savefig(save_path, bbox_inches='tight')  # Ensure the plot fits within the saved image
#     plt.close()  # Close the plot to avoid memory issues

#     return save_path

###11***
# def generate_scatter_plot(delayed_tasks, user_id):
#     """
#     Generate a scatter plot of task delays over time with a trend line.
#     Returns the path to the saved image file.
#     """
#     # Convert tasks data to a DataFrame
#     df = pd.DataFrame(delayed_tasks)
    
#     # Convert timestamp to datetime
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
#     df['date'] = df['dateTime'].dt.date

#     # Aggregate delays by date
#     task_summary = df.groupby('date')['delay'].sum().reset_index()

#     # Plotting the scatter plot
#     plt.figure(figsize=(12, 6))

#     # Plot delays over time as a scatter plot (blue dots)
#     plt.scatter(task_summary['date'], task_summary['delay'], color='b')

#     # Add a trend line (blue line)
#     plt.plot(task_summary['date'], task_summary['delay'], linestyle='-', color='b')

#     # Customize the chart
#     plt.title('Task Delays Over Time')
#     plt.xlabel('Date')
#     plt.ylabel('Delay (minutes)')

#     # Format x-axis to only show dates with actual values
#     plt.xticks(task_summary['date'], [date.strftime('%d-%m') for date in task_summary['date']], rotation=45)

#     # Remove the legend
#     plt.legend().remove()

#     # Save the plot to the 'charts' folder
#     save_path = f'charts/scatter_plot_{user_id}.png'
#     plt.savefig(save_path, bbox_inches='tight')  # Ensure the plot fits within the saved image
#     plt.close()  # Close the plot to avoid memory issues

#     return save_path



##testtt


####**** saved in firestore
# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         logging.info(f"Fetching tasks for user: {user_id}")
        
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             logging.warning(f"No tasks found for user: {user_id}")
#             return jsonify({"error": "No tasks found for the user"}), 404

#         logging.info(f"Tasks data fetched: {len(tasks_data)} tasks")

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
#         logging.info("Tasks data converted to DataFrame")

#         # Filter tasks that have a 'delay' field (only delayed tasks)
#         delayed_tasks = df[df['delay'].notnull()].copy()
#         logging.info(f"Filtered delayed tasks: {len(delayed_tasks)} tasks")

#         # Check if there are any delayed tasks
#         if delayed_tasks.empty:
#             logging.warning("No delayed tasks found. Skipping scatter plot generation.")
#             scatter_plot_path = None
#         else:
#             # Validate and filter tasks with a valid 'dateTime' field
#             if 'dateTime' not in delayed_tasks.columns:
#                 logging.error("The 'dateTime' field is missing in the tasks data")
#                 return jsonify({"error": "The 'dateTime' field is missing in the tasks data"}), 400

#             delayed_tasks = delayed_tasks[delayed_tasks['dateTime'].notnull()].copy()
#             logging.info(f"Filtered tasks with valid 'dateTime': {len(delayed_tasks)} tasks")

#             # Log the first few tasks for debugging
#             logging.info("Sample delayed tasks:")
#             for index, task in delayed_tasks.head().iterrows():
#                 logging.info(f"Task ID: {task.get('id')}, Title: {task.get('title')}, DateTime: {task.get('dateTime')}, Delay: {task.get('delay')}")

#             # Generate scatter plot
#             scatter_plot_path = generate_scatter_plot(delayed_tasks.to_dict('records'), user_id)
#             logging.info(f"Scatter plot saved at: {scatter_plot_path}")

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0
#         logging.info(f"Calculated average delay: {average_delay}")

#         # Most frequently delayed tasks
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict() if not delayed_tasks.empty else {}
#         logging.info(f"Most frequently delayed tasks: {most_delayed_tasks}")

#         # Time of day analysis
#         if not delayed_tasks.empty:
#             delayed_tasks.loc[:, 'hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#             time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()
#         else:
#             time_of_day_delays = {}
#         logging.info(f"Time of day delays: {time_of_day_delays}")

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(df[df['isDone'] == True]),  # Count all completed tasks
#             'delayed_tasks': len(delayed_tasks),  # Count only delayed tasks
#             'incomplete_tasks': len(df[df['isDone'] == False]),  # Count incomplete tasks
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot_path': scatter_plot_path,  # Path to the saved scatter plot image (or None if no delayed tasks)
#             'timestamp': datetime.now().isoformat()
#         }

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)
#         logging.info("Analysis data saved to Firestore")

#         # Return the analysis data and scatter plot path as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         logging.error(f"Error in analyze_tasks: {str(e)}", exc_info=True)
#         return jsonify({"error": str(e)}), 500

# def generate_scatter_plot(delayed_tasks, user_id):
#     """
#     Generate a scatter plot of task delays over time and save it as an image file.
#     Returns the path to the saved image file.
#     """
#     # Convert tasks data to a DataFrame
#     df = pd.DataFrame(delayed_tasks)
    
#     # Convert timestamp to datetime
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
#     df['date'] = df['dateTime'].dt.date

#     # Aggregate delays by date
#     task_summary = df.groupby('date')['delay'].sum().reset_index()

#     # Plotting the scatter plot
#     plt.figure(figsize=(12, 6))

#     # Plot delays over time as a scatter plot (blue dots)
#     plt.scatter(task_summary['date'], task_summary['delay'], color='b')

#     # Add a trend line (blue line)
#     plt.plot(task_summary['date'], task_summary['delay'], linestyle='-', color='b')

#     # Customize the chart
#     plt.title('Task Delays Over Time')
#     plt.xlabel('Date')
#     plt.ylabel('Delay (minutes)')

#     # Format x-axis to only show dates with actual values
#     plt.xticks(task_summary['date'], [date.strftime('%d-%m') for date in task_summary['date']], rotation=45)

#     # Remove the legend
#     plt.legend().remove()

#     # Save the plot to the 'charts' folder
#     save_path = f'charts/scatter_plot_{user_id}.png'
#     plt.savefig(save_path, bbox_inches='tight')  # Ensure the plot fits within the saved image
#     plt.close()  # Close the plot to avoid memory issues

#     return save_path




##### response succussful*****
# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         logger.info(f"Fetching tasks for user: {user_id}")
        
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             logger.warning(f"No tasks found for user: {user_id}")
#             return jsonify({"error": "No tasks found for the user"}), 404

#         logger.info(f"Tasks data fetched: {len(tasks_data)} tasks")

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
#         logger.info("Tasks data converted to DataFrame")

#         # Filter completed tasks (only tasks with isDone == True and completedAt is not null)
#         completed_tasks = df[(df['isDone'] == True) & (df['completedAt'].notnull())].copy()
#         logger.info(f"Filtered completed tasks: {len(completed_tasks)} tasks")

#         # Calculate delays for completed tasks
#         completed_tasks.loc[:, 'delay'] = completed_tasks.apply(calculate_delay, axis=1)
#         logger.info("Delays calculated for completed tasks")

#         # Convert the 'delay' column to numeric, handling errors by setting invalid values to NaN
#         completed_tasks['delay'] = pd.to_numeric(completed_tasks['delay'], errors='coerce')
#         logger.info("Converted 'delay' column to numeric")

#         # Drop rows with NaN values in the 'delay' column
#         completed_tasks = completed_tasks.dropna(subset=['delay'])
#         logger.info(f"Filtered tasks with valid delays: {len(completed_tasks)} tasks")

#         # Filter delayed tasks (delay > 0)
#         delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]
#         logger.info(f"Filtered delayed tasks: {len(delayed_tasks)} tasks")

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0
#         logger.info(f"Calculated average delay: {average_delay}")

#         # Most frequently delayed tasks
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict() if not delayed_tasks.empty else {}
#         logger.info(f"Most frequently delayed tasks: {most_delayed_tasks}")

#         # Time of day analysis
#         if not delayed_tasks.empty:
#             delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#             time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()
#         else:
#             time_of_day_delays = {}
#         logger.info(f"Time of day delays: {time_of_day_delays}")

#         # Generate scatter plot
#         scatter_plot_path = generate_scatter_plot(delayed_tasks.to_dict('records'), user_id) if not delayed_tasks.empty else None
#         logger.info(f"Scatter plot saved at: {scatter_plot_path}")

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(completed_tasks),
#             'delayed_tasks': len(delayed_tasks),
#             'incomplete_tasks': len(df[df['isDone'] == False]),  # Count incomplete tasks
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot_path': scatter_plot_path,  # Path to the saved scatter plot image
#             'timestamp': datetime.now().isoformat()
#         }

#         # Log the analysis data for debugging
#         logger.info(f"Analysis data to be saved: {analysis_data}")

#         # Save analysis data to Firestore
#         save_analysis_to_firestore(user_id, analysis_data)

#         # Return the analysis data and scatter plot path as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         logger.error(f"Error in analyze_tasks: {str(e)}", exc_info=True)
#         return jsonify({"error": str(e)}), 500

# def save_analysis_to_firestore(user_id, analysis_data):
#     """
#     Save analysis data to Firestore.
#     """
#     try:
#         # Validate analysis data before saving to Firestore
#         if not all(isinstance(key, str) and isinstance(value, (str, int, float, dict, list)) for key, value in analysis_data.items()):
#             logger.error("Invalid data in analysis_data. Skipping Firestore save.")
#             return False

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)
#         logger.info("Analysis data saved to Firestore")
#         return True

#     except Exception as e:
#         logger.error(f"Error saving analysis data to Firestore: {str(e)}", exc_info=True)
#         return False

# def generate_scatter_plot(delayed_tasks, user_id):
#     """
#     Generate a scatter plot for delayed tasks and save it to the charts folder.
#     Returns the path to the saved scatter plot image.
#     """
#     try:
#         if not delayed_tasks:
#             logger.warning("No delayed tasks found. Skipping scatter plot generation.")
#             return None

#         # Your scatter plot generation logic here
#         # Example: Save the scatter plot to a file and return the path
#         scatter_plot_path = f"charts/scatter_plot_{user_id}.png"
#         logger.info(f"Scatter plot saved at: {scatter_plot_path}")
#         return scatter_plot_path

#     except Exception as e:
#         logger.error(f"Error generating scatter plot: {str(e)}", exc_info=True)
#         return None

# def calculate_delay(task_data):
#     """
#     Calculate the delay between the scheduled time and the completion time.
#     Returns the delay in minutes.
#     """
#     if 'dateTime' not in task_data or 'completedAt' not in task_data or not task_data['completedAt']:
#         logger.warning("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
#         return None

#     try:
#         scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
#         completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
#         delay = (completed_time - scheduled_time).total_seconds() / 60
#         logger.info(f"Calculated Delay: {delay}")
#         return delay
#     except Exception as e:
#         logger.error(f"Error calculating delay: {e}")
#         return None

####succussful without firestore only ### ###
# @app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
# def analyze_tasks(user_id):
#     try:
#         logger.info(f"Fetching tasks for user: {user_id}")
        
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if not tasks_data:
#             logger.warning(f"No tasks found for user: {user_id}")
#             return jsonify({"error": "No tasks found for the user"}), 404

#         logger.info(f"Tasks data fetched: {len(tasks_data)} tasks")

#         # Convert tasks data to a DataFrame
#         df = pd.DataFrame(tasks_data)
#         logger.info("Tasks data converted to DataFrame")

#         # Filter completed tasks (only tasks with isDone == True and completedAt is not null)
#         completed_tasks = df[(df['isDone'] == True) & (df['completedAt'].notnull())].copy()
#         logger.info(f"Filtered completed tasks: {len(completed_tasks)} tasks")

#         # Calculate delays for completed tasks
#         completed_tasks.loc[:, 'delay'] = completed_tasks.apply(calculate_delay, axis=1)
#         logger.info("Delays calculated for completed tasks")

#         # Convert the 'delay' column to numeric, handling errors by setting invalid values to NaN
#         completed_tasks['delay'] = pd.to_numeric(completed_tasks['delay'], errors='coerce')
#         logger.info("Converted 'delay' column to numeric")

#         # Drop rows with NaN values in the 'delay' column
#         completed_tasks = completed_tasks.dropna(subset=['delay'])
#         logger.info(f"Filtered tasks with valid delays: {len(completed_tasks)} tasks")

#         # Filter delayed tasks (delay > 0)
#         delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]
#         logger.info(f"Filtered delayed tasks: {len(delayed_tasks)} tasks")

#         # Calculate average delay
#         average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0
#         logger.info(f"Calculated average delay: {average_delay}")

#         # Most frequently delayed tasks
#         most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict() if not delayed_tasks.empty else {}
#         logger.info(f"Most frequently delayed tasks: {most_delayed_tasks}")

#         # Time of day analysis
#         if not delayed_tasks.empty:
#             delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
#             time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()
#         else:
#             time_of_day_delays = {}
#         logger.info(f"Time of day delays: {time_of_day_delays}")

#         # Generate scatter plot
#         scatter_plot_path = generate_scatter_plot(delayed_tasks.to_dict('records'), user_id) if not delayed_tasks.empty else None
#         logger.info(f"Scatter plot saved at: {scatter_plot_path}")

#         # Prepare analysis data
#         analysis_data = {
#             'user_id': user_id,
#             'total_tasks': len(df),
#             'completed_tasks': len(completed_tasks),
#             'delayed_tasks': len(delayed_tasks),
#             'incomplete_tasks': len(df[df['isDone'] == False]),  # Count incomplete tasks
#             'average_delay': average_delay,
#             'most_delayed_tasks': most_delayed_tasks,
#             'time_of_day_delays': time_of_day_delays,
#             'scatter_plot_path': scatter_plot_path,  # Path to the saved scatter plot image
#             'timestamp': datetime.now().isoformat()
#         }

#         # Log the analysis data for debugging
#         logger.info(f"Analysis data to be saved: {analysis_data}")

#         # Save analysis data to Firestore
#         save_analysis_to_firestore(user_id, analysis_data)

#         # Return the analysis data and scatter plot path as a response
#         return jsonify(analysis_data), 200

#     except Exception as e:
#         logger.error(f"Error in analyze_tasks: {str(e)}", exc_info=True)
#         return jsonify({"error": str(e)}), 500


# def save_analysis_to_firestore(user_id, analysis_data):
#     """
#     Save analysis data to Firestore.
#     """
#     try:
#         # Validate analysis data before saving to Firestore
#         if not all(isinstance(key, str) and isinstance(value, (str, int, float, dict, list)) for key, value in analysis_data.items()):
#             logger.error("Invalid data in analysis_data. Skipping Firestore save.")
#             return False

#         # Save analysis data to Firestore
#         analysis_ref = db.collection('users').document(user_id).collection('analysis')
#         analysis_ref.add(analysis_data)
#         logger.info("Analysis data saved to Firestore")
#         return True

#     except Exception as e:
#         logger.error(f"Error saving analysis data to Firestore: {str(e)}", exc_info=True)
#         return False


# def calculate_delay(task_data):
#     """
#     Calculate the delay between the scheduled time and the completion time.
#     Returns the delay in minutes.
#     """
#     if 'dateTime' not in task_data or 'completedAt' not in task_data or not task_data['completedAt']:
#         logger.warning("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
#         return None

#     try:
#         scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
#         completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
#         delay = (completed_time - scheduled_time).total_seconds() / 60
#         logger.info(f"Calculated Delay: {delay}")
#         return delay
#     except Exception as e:
#         logger.error(f"Error calculating delay: {e}")
#         return None

# def generate_scatter_plot(delayed_tasks, user_id):
#     """
#     Generate a scatter plot of task delays over time with a trend line.
#     Returns the path to the saved image file.
#     """
#     # Convert tasks data to a DataFrame
#     df = pd.DataFrame(delayed_tasks)
    
#     # Convert timestamp to datetime
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
#     df['date'] = df['dateTime'].dt.date

#     # Aggregate delays by date
#     task_summary = df.groupby('date')['delay'].sum().reset_index()

#     # Plotting the scatter plot
#     plt.figure(figsize=(12, 6))

#     # Plot delays over time as a scatter plot (blue dots)
#     plt.scatter(task_summary['date'], task_summary['delay'], color='b', label='Delays')

#     # Add a trend line (blue line)
#     plt.plot(task_summary['date'], task_summary['delay'], linestyle='-', color='b', label='Trend Line')

#     # Customize the chart
#     plt.title('Task Delays Over Time', fontsize=16)
#     plt.xlabel('Date', fontsize=14)
#     plt.ylabel('Delay (minutes)', fontsize=14)

#     # Format x-axis to only show dates with actual values
#     plt.xticks(task_summary['date'], [date.strftime('%d-%m') for date in task_summary['date']], rotation=45)

#     # # Add grid for better readability
#     # plt.grid(True, linestyle='--', alpha=0.7)

#     # Remove the legend
#     plt.legend().remove()

#     # Save the plot to the 'charts' folder
#     save_path = f'charts/scatter_plot_{user_id}.png'
#     plt.savefig(save_path, bbox_inches='tight')  # Ensure the plot fits within the saved image
#     plt.close()  # Close the plot to avoid memory issues

#     return save_path

# ######



###3 succussful with firestore #####################*******************
@app.route('/users/<user_id>/analyze-tasks', methods=['GET'])
def analyze_tasks(user_id):
    try:
        logger.info(f"Fetching tasks for user: {user_id}")
        
        # Fetch tasks for the user
        tasks_data = get_tasks_for_user(user_id)
        
        if not tasks_data:
            logger.warning(f"No tasks found for user: {user_id}")
            return jsonify({"error": "No tasks found for the user"}), 404

        logger.info(f"Tasks data fetched: {len(tasks_data)} tasks")

        # Convert tasks data to a DataFrame
        df = pd.DataFrame(tasks_data)
        logger.info("Tasks data converted to DataFrame")

        # Filter completed tasks (only tasks with isDone == True and completedAt is not null)
        completed_tasks = df[(df['isDone'] == True) & (df['completedAt'].notnull())].copy()
        logger.info(f"Filtered completed tasks: {len(completed_tasks)} tasks")

        # Calculate delays for completed tasks
        completed_tasks.loc[:, 'delay'] = completed_tasks.apply(calculate_delay, axis=1)
        logger.info("Delays calculated for completed tasks")

        # Convert the 'delay' column to numeric, handling errors by setting invalid values to NaN
        completed_tasks['delay'] = pd.to_numeric(completed_tasks['delay'], errors='coerce')
        logger.info("Converted 'delay' column to numeric")

        # Drop rows with NaN values in the 'delay' column
        completed_tasks = completed_tasks.dropna(subset=['delay'])
        logger.info(f"Filtered tasks with valid delays: {len(completed_tasks)} tasks")

        # Filter delayed tasks (delay > 0)
        delayed_tasks = completed_tasks[completed_tasks['delay'] > 0]
        logger.info(f"Filtered delayed tasks: {len(delayed_tasks)} tasks")

        # Calculate average delay
        average_delay = delayed_tasks['delay'].mean() if not delayed_tasks.empty else 0
        logger.info(f"Calculated average delay: {average_delay}")

        # Most frequently delayed tasks
        most_delayed_tasks = delayed_tasks.groupby('title')['delay'].sum().nlargest(5).to_dict() if not delayed_tasks.empty else {}
        logger.info(f"Most frequently delayed tasks: {most_delayed_tasks}")

        # Time of day analysis
        if not delayed_tasks.empty:
            delayed_tasks['hour'] = delayed_tasks['dateTime'].apply(lambda x: datetime.fromtimestamp(x / 1000).hour)
            time_of_day_delays = delayed_tasks['hour'].value_counts().to_dict()
        else:
            time_of_day_delays = {}
        logger.info(f"Time of day delays: {time_of_day_delays}")

        # Generate scatter plot
        # scatter_plot_path = generate_scatter_plot(delayed_tasks.to_dict('records'), user_id) if not delayed_tasks.empty else None
        
        scatter_plot_path = generate_scatter_plot(delayed_tasks.to_dict('records'), user_id) if not delayed_tasks.empty else None
        logger.info(f"Scatter plot saved at: {scatter_plot_path}")

        # Prepare analysis data
        analysis_data = {
            'user_id': user_id,
            'total_tasks': len(df),
            'completed_tasks': len(completed_tasks),
            'delayed_tasks': len(delayed_tasks),
            'incomplete_tasks': len(df[df['isDone'] == False]),  # Count incomplete tasks
            'average_delay': average_delay,
            'most_delayed_tasks': most_delayed_tasks,
            'time_of_day_delays': time_of_day_delays,
            # 'scatter_plot_path': scatter_plot_path,  # Path to the saved scatter plot image
            'scatter_plot_url': f'http://your-server-url/{scatter_plot_path}',  # Return the scatter plot URL
            'timestamp': datetime.now().isoformat()
        }

        # Log the analysis data for debugging
        logger.info(f"Analysis data to be saved: {analysis_data}")

        # Save analysis data to Firestore
        save_analysis_to_firestore(user_id, analysis_data)

        # Return the analysis data and scatter plot path as a response
        return jsonify(analysis_data), 200

    except Exception as e:
        logger.error(f"Error in analyze_tasks: {str(e)}", exc_info=True)
        return jsonify({"error": str(e)}), 500

def save_analysis_to_firestore(user_id, analysis_data):
    """
    Save analysis data to Firestore.
    """
    try:
        # Convert all keys to strings (including nested dictionaries)
        def convert_keys_to_strings(data):
            if isinstance(data, dict):
                return {str(key): convert_keys_to_strings(value) for key, value in data.items()}
            elif isinstance(data, (list, tuple)):
                return [convert_keys_to_strings(item) for item in data]
            else:
                return data

        # Convert keys in analysis_data to strings
        valid_data = convert_keys_to_strings(analysis_data)

        # Validate analysis data before saving to Firestore
        if not all(isinstance(key, str) and key.strip() != "" for key in valid_data.keys()):
            invalid_keys = [key for key in valid_data.keys() if not isinstance(key, str) or key.strip() == ""]
            logger.error(f"Invalid keys in analysis_data: {invalid_keys}. Skipping Firestore save.")
            return False

        # Save analysis data to Firestore
        # analysis_ref = db.collection('users').document(user_id).collection('analysis')
        # analysis_ref.add(valid_data)

        # Save analysis data to Firestore (overwrite existing document)
        analysis_ref = db.collection('users').document(user_id).collection('analysis').document(user_id)
        analysis_ref.set(valid_data, merge=True)  # Use merge=True to update existing fields
        
        logger.info("Analysis data saved to Firestore")
        return True

    except Exception as e:
        logger.error(f"Error saving analysis data to Firestore: {str(e)}", exc_info=True)
        return False



def calculate_delay(task_data):
    """
    Calculate the delay between the scheduled time and the completion time.
    Returns the delay in minutes.
    """
    if 'dateTime' not in task_data or 'completedAt' not in task_data or not task_data['completedAt']:
        logger.warning("Task is missing 'dateTime' or 'completedAt' field, or 'completedAt' is null.")
        return None

    try:
        scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
        completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
        delay = (completed_time - scheduled_time).total_seconds() / 60
        logger.info(f"Calculated Delay: {delay}")
        return delay
    except Exception as e:
        logger.error(f"Error calculating delay: {e}")
        return None

def generate_scatter_plot(delayed_tasks, user_id):
    """
    Generate a scatter plot of task delays over time with a trend line.
    Returns the path to the saved image file.
    """
    # Convert tasks data to a DataFrame
    df = pd.DataFrame(delayed_tasks)
    
    # Convert timestamp to datetime
    df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
    df['date'] = df['dateTime'].dt.date

    # Aggregate delays by date
    task_summary = df.groupby('date')['delay'].sum().reset_index()

    # Plotting the scatter plot
    plt.figure(figsize=(12, 6))

    # Plot delays over time as a scatter plot (blue dots)
    plt.scatter(task_summary['date'], task_summary['delay'], color='b', label='Delays')

    # Add a trend line (blue line)
    plt.plot(task_summary['date'], task_summary['delay'], linestyle='-', color='b', label='Trend Line')

    # Customize the chart
    plt.title('Task Delays Over Time', fontsize=16)
    plt.xlabel('Date', fontsize=14)
    plt.ylabel('Delay (minutes)', fontsize=14)

    # Format x-axis to only show dates with actual values
    plt.xticks(task_summary['date'], [date.strftime('%d-%m') for date in task_summary['date']], rotation=45)

    # Remove the legend
    plt.legend().remove()

    # Save the plot to the 'charts' folder
    save_path = f'charts/scatter_plot_{user_id}.png'
    plt.savefig(save_path, bbox_inches='tight')  # Ensure the plot fits within the saved image
    plt.close()  # Close the plot to avoid memory issues

    return save_path

########*********************************************************************


############ suggestions  //////////////////////
#Percentage of Delay per Day
def calculate_percentage_delay(task_data):
    if 'dateTime' in task_data and 'completedAt' in task_data and task_data['completedAt']:
        scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
        completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
        delay = (completed_time - scheduled_time).total_seconds() / 60  # Delay in minutes
        scheduled_duration = (scheduled_time - scheduled_time.replace(hour=0, minute=0, second=0)).total_seconds() / 60
        percentage_delay = (delay / scheduled_duration) * 100
        return percentage_delay
    return None

#Categorize Completion Time / Task Completion Distribution
def categorize_completion_time(task_data):
    if 'dateTime' in task_data and 'completedAt' in task_data and task_data['completedAt']:
        scheduled_time = pd.to_datetime(task_data['dateTime'], unit='ms')
        completed_time = pd.to_datetime(task_data['completedAt'], unit='ms')
        delay = (completed_time - scheduled_time).total_seconds() / 60  # Delay in minutes

        if delay < -5:
            return "Early"
        elif -5 <= delay <= 5:
            return "On Time"
        elif 5 < delay <= 60:
            return "Slightly Delayed"
        else:
            return "Highly Delayed"
    return "Not Completed"

#Weekly and Monthly Summaries
def calculate_weekly_summary(tasks):
    weekly_summary = {}
    for task in tasks:
        task_data = task.to_dict()
        day = pd.to_datetime(task_data['dateTime'], unit='ms').date()
        week = day.isocalendar()[1]  # Get week number
        delay = calculate_delay(task_data)

        if week in weekly_summary:
            weekly_summary[week].append(delay)
        else:
            weekly_summary[week] = [delay]

    # Calculate average delay per week
    average_weekly_delays = {week: sum(delays) / len(delays) for week, delays in weekly_summary.items()}
    return average_weekly_delays









'''
@app.route('/users/<user_id>/adaptive-reminder-strategy', methods=['GET'])
def adaptive_reminder_strategy(user_id):
    try:
        # Fetch all tasks for the user
        tasks_data = get_tasks_for_user(user_id)
        
        if isinstance(tasks_data, list) and tasks_data:
            df = pd.DataFrame(tasks_data)
            
            # Calculate delays
            df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')
            df['completedAt'] = pd.to_datetime(df['completedAt'], unit='ms', errors='coerce')
            df['delay_minutes'] = (df['completedAt'] - df['dateTime']).dt.total_seconds() / 60

            # Delay Statistics
            delay_stats = {
                'mean_delay': df['delay_minutes'].mean(),
                'median_delay': df['delay_minutes'].median(),
                'std_delay': df['delay_minutes'].std(),
                'recent_trend': calculate_delay_trend(df)
            }

            # Adaptive Reminder Strategy
            reminder_strategy = calculate_reminder_frequency(delay_stats)

            return jsonify({
                'delay_statistics': delay_stats,
                'reminder_strategy': reminder_strategy
            })

        return jsonify({"error": "No tasks found for the user"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

def calculate_delay_trend(df):
    """
    Calculate the trend of delays over time
    Returns:
    - 'increasing': Delays are getting worse
    - 'stable': Delays are consistent
    - 'decreasing': Delays are improving
    """
    if len(df) < 3:
        return 'stable'
    
    # Use linear regression to determine trend
    df['task_order'] = range(len(df))
    from scipy import stats
    slope, _, _, _, _ = stats.linregress(df['task_order'], df['delay_minutes'])
    
    if slope > 0.5:
        return 'increasing'
    elif slope < -0.5:
        return 'decreasing'
    else:
        return 'stable'

def calculate_reminder_frequency(delay_stats):
    """
    Dynamically calculate reminder frequency based on delay statistics
    """
    mean_delay = delay_stats['mean_delay']
    trend = delay_stats['recent_trend']
    
    # Base reminder calculation
    if trend == 'increasing':
        # More aggressive reminders if delays are worsening
        if mean_delay > 120:  # > 2 hours
            return {
                'reminders_per_day': 5,
                'reminder_intervals': [2, 4, 6, 8, 10],
                'severity': 'high'
            }
        elif mean_delay > 60:  # 1-2 hours
            return {
                'reminders_per_day': 3,
                'reminder_intervals': [3, 6, 9],
                'severity': 'medium'
            }
    elif trend == 'stable':
        # Moderate reminders for consistent performance
        if mean_delay > 60:
            return {
                'reminders_per_day': 2,
                'reminder_intervals': [4, 8],
                'severity': 'low'
            }
    elif trend == 'decreasing':
        # Fewer, less intrusive reminders if performance is improving
        return {
            'reminders_per_day': 1,
            'reminder_intervals': [6],
            'severity': 'minimal'
        }
    
    # Default strategy
    return {
        'reminders_per_day': 2,
        'reminder_intervals': [4, 8],
        'severity': 'standard'
    }
'''

if __name__ == '__main__':
    # app.run(debug=True, host='0.0.0.0', port=5000)
    app.run(debug=True)
