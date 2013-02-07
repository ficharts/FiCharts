<?php



function generateOrder(){

	$db = mysql_connect("localhost", "u115139", "t4yp6KgA");
	mysql_select_db("u115139", $db);

	//mysql_query("INSERT INTO record (name, value, date) VALUES ('order', 1, now())");

	// 获取旧数据记录
	$result = mysql_query("SELECT * FROM record where name = 'order'");


	

	while($row = mysql_fetch_array($result)){
	 
	  $order_no = $row["value"];

	 }

	
	 // 更新记录
	$new_order_no = $order_no + 1;

	echo $new_order_no;
	mysql_query("UPDATE record SET value = $new_order_no
					WHERE name = 'order'");

	mysql_close($db);
	
	return $new_order_no;

}





































?>