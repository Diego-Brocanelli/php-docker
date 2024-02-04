<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono&display=swap" rel="stylesheet">
    <title>PHP Docker V2.0.0</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            border: 0;
            font: inherit;
            vertical-align: baseline;
        }
        body {
            font-family: 'JetBrains Mono', monospace;
            background-color: #f5f5f7;
        }
        h1 {
            margin-top: 2%;
            font-size: 28pt;
        }

        h2 {
            font-size: 22pt;
        }

        h3 {
            font-size: 16pt;
        }

        h1, h2, h3, h5, p {
            text-align: center;
        }
        h2, h3 {
            margin-top: 6%;
            margin-bottom: 2%;
        }

        h5 {
            margin-bottom: 5%;
        }

        p {
            margin-bottom: 3%;
        }

        ul {
            margin-top: 3%;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
        }
        li {
            cursor:default;
            flex-direction: row;
            flex-wrap: wrap;
            float: left;
            list-style-type: none;
            border: 1px solid #1d1d1f;
            padding-top: 0.5rem;
            padding-bottom: 0.5rem;
            padding-left: 1rem;
            padding-right: 1rem;
            margin: 1rem;
            border-radius: 20px;
            background-color: #f5f5f7;
        }

        li:hover {
            background-color: #1d1d1f;
            color: #30c4c4;
        }

        footer {
            text-align: center;
            position: relative;
            bottom: -20px;
            color:#1d1d1f;
            font-size: 10pt;
            margin-top:3%;
            margin-bottom:3%;
            background-color: #e7e7ed;
            padding-top: 3%;
            padding-bottom: 3%;
            a {
                color: #30c4c4;
            }
        }

        #technologies {
            background-color: #e7e7ed;
            width: 100%;
            padding-top: 1rem;
            padding-bottom: 4rem;
        }

        .terminal {
            width: 50%;
            margin: 0 auto;
            background-color: #242424;
            border-radius: 15px;
            margin-bottom: 3%;
        }

        .menu {
            background-color: #373737;
            display: flex;
            padding-top: 10px;
            padding-bottom: 10px;
            padding-left:15px;
            border-top-right-radius: 15px;
            border-top-left-radius: 15px;
        }

        .menu span {
            font-size: 8pt;
            color:#bababa;
            margin-left: 30%;
            position: relative;
            top:5px;
        }

        .menu button {
            width: 20px;
            flex-direction: row;
            margin-right: 5px;
            border-radius: 10px;
            background-color: #ff5054;
            color:transparent;
        }

        .menu button:nth-child(2) {
            background-color: #ffb931;
        }

        .menu button:nth-child(3) {
            background-color: #00cc33;
        }

        .screen {
            padding-top: 20px;
            padding-bottom: 20px;
            padding-left: 20px;
            background-color: #242424;
            color: #30c4c4;
            box-sizing: border-box;
            border-bottom-right-radius: 15px;
            border-bottom-left-radius: 15px;
        }

        p a {
            color: #30c4c4;
        }

        @media only screen and (max-width: 576px) {
            h1, h2, h3, h5, p {
                margin-top: 15%;
                margin-bottom: 10%;
            }

            .terminal {
                width: 98%;
            }

            .menu span {
                margin-left: 30px;
            }
        }

        @media only screen and (max-width: 992px ) {
            .terminal {
                width: 98%;
                margin-bottom: 8%;
            }

            footer {
                padding-top: 5%;
                padding-bottom: 5%;
            }
        }
    </style>
</head>
    <body>

        <h1>Welcome PHP Docker</h1>

        <h5>V2.0.0</h5>

        <p>Build your applications quickly</p>

        <section id="technologies">
            <h2>Technologies</h2>

            <ul>
                <li>PHP 8.3</li>

                <li>MySQL 8</li>

                <li>Nginx</li>

                <li>Redis</li>

                <li>RabbitMQ</li>
            </ul>
        </section>

        <h2>Tools</h2>

        <ul>
            <li>Composer</li>

            <li>Composer-unused</li>

            <li>Nodejs</li>

            <li>NPM</li>

            <li>PHP 8.1</li>

            <li>PHPCs</li>

            <li>PHPLoc</li>

            <li>PHPStan</li>

            <li>PHPUnit</li>

            <li>Psalm</li>
        </ul>

        <h3>How to use the tools</h3>

        <p>
            Run the command below in the project root
        </p>

        <div class="terminal">
            <div class="menu">
                <button>.</button>
                <button>.</button>
                <button>.</button>
                <span>Tilix: ~/projects/php-docker</span>
            </div>
            <div class="screen">
                $ ./container composer install
            </div>
        </div>

        <div class="terminal">
            <div class="menu">
                <button>.</button>
                <button>.</button>
                <button>.</button>
                <span>Tilix: ~/projects/php-docker</span>
            </div>
            <div class="screen">
                $ ./container phpunit tests
            </div>
        </div>

        <div class="terminal">
            <div class="menu">
                <button>.</button>
                <button>.</button>
                <button>.</button>
                <span>Tilix: ~/projects/php-docker</span>
            </div>
            <div class="screen">
                $ ./container npm install
            </div>
        </div>

        <p>
            <a href="https://github.com/Diego-Brocanelli/php-docker/blob/main/docs/development/commands.md" target="_blank">
                See all commands
            </a>
        </p>

        <h3>Accessing bash</h3>

        <div class="terminal">
            <div class="menu">
                <button>.</button>
                <button>.</button>
                <button>.</button>
                <span>Tilix: ~/projects/php-docker</span>
            </div>
            <div class="screen">
                $ docker exec -it app bash
            </div>
        </div>

        <footer>
            PHP Docker created by <a href="https://www.diegobrocanelli.com.br/">Diego Brocanelli</a>
        </footer>
    </body>
</html>
