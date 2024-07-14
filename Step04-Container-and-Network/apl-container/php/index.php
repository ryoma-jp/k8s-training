<html>
    <head>
        <title>APL Container</title>
    </head>
    <body>
        <?php
            $servername = "mysql";
            $database = "mysql";

            $username = getenv('MYSQL_USER');
            $password = getenv('MYSQL_PASSWORD');

            try {
                $dsn = "mysql:host=$servername;dbname=$database";
                $conn = new PDO($dsn, $username, $password);
                $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                print("<p>Connected successfully</p>");
            } catch (PDOException $e) {
                print("<p>Connection failed: " . $e->getMessage() . "</p>");
            }

            $conn = null;
            print("<p>Closed connection</p>");

        ?>
    </body>
</html>
