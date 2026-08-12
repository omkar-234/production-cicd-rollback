from flask import Flask

app = Flask(__name__)

VERSION = "1.0"

@app.route('/')
def home():
    return f'''
    <h1>🚀 Production App</h1>
    <p>Version: {VERSION}</p>
    <p>Built by: Omkar Bachche</p>
    <p>Status: Running ✅</p>
    '''

@app.route('/health')
def health():
    return {"status": "healthy", "version": VERSION}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
