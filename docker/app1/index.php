<?php

$conn = new mysqli(
    "192.168.56.10",
    "dmzuser",
    "password123",
    "project_vkj"
);

?>

<!DOCTYPE html>
<html>
<head>
    <title>APP1 PHP</title>
</head>

<body>

<h1>APP1 - PHP</h1>

<?php

if ($conn->connect_error) {

    echo "<h2>Database Failed ❌</h2>";

} else {

    echo "<h2>Database Connected ✅</h2>";

}

?>

<p>Server Time:
<?= date("Y-m-d H:i:s") ?>
</p>

</body>
</html>