from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health')
def health():
    # Simulate a healthy response
    return jsonify({
        "status": "error",
        "database": "unhealthy"
    }), 500

if __name__ == '__main__':
    app.run(port=5000)