# from flask import Flask, request, jsonify
# from flask_cors import CORS
# import pandas as pd
# app = Flask(__name__)
# CORS(app)
# @app.route('/analyze', methods=['POST'])
# def analyze():
#     data = request.json  # Get task data as JSON
#     if not data:
#         return jsonify({'error': 'No data provided'}), 400

#     # Convert JSON to DataFrame
#     df = pd.DataFrame(data)
#     df['dateTime'] = pd.to_datetime(df['dateTime'])

#     # Perform time series analysis
#     time_series = df.groupby(df['dateTime'].dt.date)['isDone'].count()

#     # Convert results to JSON
#     result = {
#         'dates': list(time_series.index.astype(str)),
#         'counts': list(time_series.values)
#     }
#     return jsonify(result)

# if __name__ == '__main__':
#     app.run(debug=True)

##################################### 

# testtt1
''''from flask import Flask
import firebase_admin
from firebase_admin import credentials, firestore
# create a Flask app instance
app = Flask(__name__)

# initialize firebase admin sdk
cred = credentials.Certificate("C:/Users/xneemoox/Desktop/graduation project/alzheimer-app-6fada-firebase-adminsdk-ry2po-b5a48bf2c5.json")
firebase_admin.initialize_app(cred)
# access firebase database
db = firestore.client()
# define a route and a function to handle requests to that route
@app.route('/') 
def hello():
    return 'Hello, World!, from Flask!'
# run the flask app
if __name__ == '__main__':
    app.run(debug=True)  '''

# test2
'''from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, firestore

# -----initialize flask app-----
app = Flask(__name__)

# -----initialize firebase admin SDK------
cred = credentials.Certificate("C:/Users/xneemoox/Desktop/graduation project/alzheimer-app-6fada-firebase-adminsdk-ry2po-b5a48bf2c5.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# -----define routes-----
@app.route('/getUsers', methods=['GET', 'POST']) # '/' => name of end point, can be anything
# http://127.0.0.1:5000/
# http://127.0.0.1:5000/getUsers 
def home():
    if request.method == 'POST':
        data = request.get_json()
        # get user name & age & create new user 
        name = data['name']
        age = data['age']
        db.collection('users').add({
            'name': name,
            'age': age})
        # jsonify => convert python code to json
        return jsonify({'message': 'User created successfully'})
    else:
        # ----if method is get => get all users from firestore----
        # fetch data from firestore
        users =[]
        docs = db.collection('users').stream()
        for docs in docs:
            users.append(docs.to_dict())
        return jsonify(users)
if __name__ == '__main__':
    app.run(debug=True)    '''


from flask import Flask, jsonify, request , render_template, send_from_directory
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
import pandas as pd
import matplotlib
matplotlib.use('Agg')  # Use a non-GUI backend for Flask
import matplotlib.pyplot as plt
# import plotly.express as px
import plotly.graph_objs as go
import json
import plotly

app = Flask(__name__, template_folder='.')
CORS(app)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("C:/Users/xneemoox/Desktop/graduation project/alzheimer-app-6fada-firebase-adminsdk-ry2po-b5a48bf2c5.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# Fetch tasks for a specific patient - successfull  
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
        
#         return jsonify(tasks_list)
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

# successfull    
# @app.route('/users/<string:user_id>/tasks-summary', methods=['GET'])
# def get_tasks_summary(user_id):
#     try:
#         user_ref = db.collection('users').document(user_id)
#         tasks_ref = user_ref.collection('tasks')
#         tasks = tasks_ref.stream()

#         summary = {}
#         for task in tasks:
#             task_data = task.to_dict()
#             print(f"Task data: {task_data}")  # Debugging line
            
#             if 'dateTime' not in task_data or 'isDone' not in task_data:
#                 print("Missing 'dateTime' or 'isDone' fields in task data.")
#                 continue

#             # Convert the timestamp to datetime if it's an integer (milliseconds)
#             if isinstance(task_data['dateTime'], int):
#                 task_data['dateTime'] = datetime.utcfromtimestamp(task_data['dateTime'] / 1000)  # Convert milliseconds to seconds

#             date_key = task_data['dateTime'].strftime('%Y-%m-%d')  # Group by date
#             if date_key not in summary:
#                 summary[date_key] = {"complete": 0, "incomplete": 0}
#             if task_data.get('isDone', False):
#                 summary[date_key]["complete"] += 1
#             else:
#                 summary[date_key]["incomplete"] += 1

#         return jsonify(summary)
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

# Sample data generation (replace with actual logic to fetch tasks) xxx
# @app.route('/users/<user_id>/tasks-summary', methods=['GET'])
# def get_task_summary(user_id):
#     # Sample data: Replace with your actual data fetching logic from Firestore or database
#     # task_data = [
#     #     {'dateTime': 1733258392666, 'isDone': True},
#     #     {'dateTime': 1733268392666, 'isDone': False},
#     #     {'dateTime': 1733278392666, 'isDone': True},
#     # ]
    
#     # Convert to DataFrame for time series
#     print(get_tasks_for_user(user_id))
#     df = pd.DataFrame(get_tasks_for_user(user_id)) #task_data
#     df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')  # Convert from milliseconds
    
#     # Aggregate the data into daily counts of completed/incomplete tasks
#     df['date'] = df['dateTime'].dt.date
#     task_summary = df.groupby('date')['isDone'].value_counts().unstack(fill_value=0).to_dict()

#     # Convert to desired format for Flutter
#     result = {}
#     for date, counts in task_summary.items():
#         result[str(date)] = {
#             'complete': counts.get(True, 0),
#             'incomplete': counts.get(False, 0),
#         }
    
#     return jsonify(result)


###


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


# Generate Time Series Chart for Task Summary
# @app.route('/users/<user_id>/tasks-summary-chart', methods=['GET'])
# def get_task_summary_chart(user_id):
#     try:
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)
        
#         if isinstance(tasks_data, list):  # Ensure the data is in the correct format
#             df = pd.DataFrame(tasks_data)
#             df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')  # Convert from milliseconds
            
#             # Aggregate the data by date and task completion status
#             df['date'] = df['dateTime'].dt.date
#             task_summary = df.groupby('date')['isDone'].value_counts().unstack(fill_value=0)

#             # Plotting the time series chart
#             plt.figure(figsize=(10, 6))

#             # Plot completed and incomplete tasks
#             task_summary[True].plot(label="Completed Tasks", marker='o', linestyle='-', color='g')
#             task_summary[False].plot(label="Incomplete Tasks", marker='o', linestyle='--', color='r')

#             # Customize the chart
#             plt.title(f'Task Completion Over Time for Patient {user_id}')
#             plt.xlabel('Date')
#             plt.ylabel('Number of Tasks')
#             plt.legend()

#             # Save the chart as a static image
#             # plt.savefig(f'task_summary_{user_id}.png')  # Save to a file or use plt.show() for inline display
#             plt.show()
#             plt.close()  # Close the plot to avoid it overlapping with others

#             # Return the path to the saved image
#             return jsonify({"chart_url": f"/path/to/your/chart/task_summary_{user_id}.png"})

#         else:
#             return jsonify({"error": "Failed to fetch tasks"}), 500

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500

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

# Serve static files
@app.route('/charts/<filename>')
def serve_chart(filename):
    return send_from_directory('charts', filename)

# plotly
# @app.route('/users/<user_id>/tasks-summary-chart', methods=['GET'])
# def get_task_summary_chart(user_id):
#     try:
#         # Fetch tasks for the user
#         tasks_data = get_tasks_for_user(user_id)

#         if isinstance(tasks_data, list):
#             df = pd.DataFrame(tasks_data)
#             df['dateTime'] = pd.to_datetime(df['dateTime'], unit='ms')

#             # Aggregate the data by date and task completion status
#             df['date'] = df['dateTime'].dt.date
#             task_summary = df.groupby('date')['isDone'].value_counts().unstack(fill_value=0)

#             # Create Plotly figure
#             trace1 = go.Scatter(
#                 x=task_summary.index.to_numpy(),  # Convert dates to list for plotly
#                 y=task_summary[True].values,
#                 name='Completed Tasks',
#                 mode='lines+markers',
#                 marker=dict(color='green'),
#                 line=dict(shape='hv')
#             )

#             trace2 = go.Scatter(
#                 x=task_summary.index.to_numpy(),
#                 y=task_summary[False].values,
#                 name='Incomplete Tasks',
#                 mode='lines+markers',
#                 marker=dict(color='red'),
#                 line=dict(shape='hv')
#             )

#             layout = go.Layout(
#                 title=f'Task Completion Over Time for Patient {user_id}',
#                 xaxis=dict(title='Date'),
#                 yaxis=dict(title='Number of Tasks')
#             )

#             # Create Plotly figure (as before)
#             fig = go.Figure(data=[trace1, trace2], layout=layout)
            
#             # # Convert the figure to JSON
#             plot_json = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)

#             return render_template('task_summary_chart.html', plot=plot_json)

#             # Render the chart as HTML
#             # return render_template('task_summary_chart.html', plot=fig.to_json())

#         else:
#             return jsonify({"error": "Failed to fetch tasks"}), 500

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
# Create a template file named task_summary_chart.html
# This template will embed the plotly chart using Javascript


###
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
