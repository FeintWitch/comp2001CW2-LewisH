from flask import Flask, render_template
import connexion

connex_app = connexion.App(__name__, specification_dir='./')
connex_app.add_api('swagger.yml')

@connex_app.route('/')
def home():
    return render_template('home.html')


if __name__ == '__main__':
    connex_app.run(host="0.0.0.0", port=8000, debug=True)
    