<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', '', "project");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$name = $_GET['name'];
		$username = $_GET['username'];
		$password = $_GET['password'];
		$phone_number = $_GET['phone_number'];
		$chooseType = $_GET['chooseType'];
		$profile = $_GET['profile'];
							
		$sql = "INSERT INTO `user`(`id`, `name`, `username`, `password`, `phone_number`, `chooseType`, `profile`)  VALUES (Null,  '$name','$username','$password','$phone_number','$chooseType','$profile')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master PlamSBB";
   
}
	mysqli_close($link);
?>