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
			
		$id = $_GET['id'];	
		$name = $_GET['name']	;
		$name_store = $_GET['name_store'];
		$phone_number = $_GET['phone_number'];
		$profile = $_GET['profile'];
		$email = $_GET['email'];
		$Token = $_GET['Token'];
		
		
		
		
							
		$sql = "UPDATE `user` SET `name_store` = '$name_store',`name` = '$name',`phone_number` = '$phone_number',`email` = '$email',`profile` = '$profile' WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master Plamsbb";
   
}

	mysqli_close($link);
?>