extends Node2D

func text(ARRAY):
	#ARRAY = ["idk", "bitch", "help"]
	for string in ARRAY:
		var text_displayed = ">" + str(string) + "\n"
		$CanvasLayer/HBoxContainer/VBoxContainer/Status/TextEdit.text += text_displayed
		
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var ARRAY = ["heyo", "I will kill you", "GOD HELP US"]
	text(ARRAY)


<<<<<<< Updated upstream
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
=======

		#come back to later
func packet_creator():
	current_packet_info = []
	
	
	
	while len(current_packet_info) != 2:
		var valid_ip_rng = rng.randi_range(1, 100)
		
		var ip_starter = null
		if valid_ip_rng <= 90:
			ip_starter = valid_ip_range
		else:
			ip_starter = "101.10"
			
		var valid_end = "false"
		
		while valid_end == "false":
			var third_octet = rng.randi_range(1,255)
			var fourth_octet = rng.randi_range(1,255)
			
			var combined_octet = str(third_octet) + "." + str(fourth_octet)
			
			if combined_octet != valid_ip_range:
				valid_end = combined_octet
		
		print(ip_starter)
		print(valid_end)
		var ip = ip_starter + "." + valid_end
		
		if len(current_packet_info) == 1:
			if current_packet_info[0] != ip:
				current_packet_info.append(ip)
		else:
			current_packet_info.append(ip)
		
	print(len(current_packet_info))
	
	current_packet_info.append("Protocol")
	current_packet_info.append(keyword)
	print(current_packet_info)


func check_if_correct_valid_packet(allowed):
			#first check sender ip, the destination ip
	var is_valid = true
	if (valid_ip_range in current_packet_info[CPI_state.SENDER_IP]) == false:
		is_valid = false
	
	if (valid_ip_range in current_packet_info[CPI_state.DESTINATION_IP]) == false:
		is_valid = false
	
	round_information_dict["Valid IP"] = is_valid
	
	
			#false = false, good, true = true, good, 
	var correct_action = false
	
	if is_valid == allowed:
				#means that either a good packet was accept or a bad one was denied
		correct_action = true
	else:
				#means that either a good packet was denied or a bad one was accepted
		correct_action = false
	
			#this will earn the player some points (majority)
	
	round_information_dict["Correct choice"] = str(correct_action)
	
	return correct_action
	
func point_giver():
	pass
	
func _on_Allow_pressed():
	round_information_dict["Deny"] = false
	round_information_dict["Allow"] = BASE_ROUND_INFO_DICT["Allow"]
	
	var result = check_if_correct_valid_packet(true)
	
	TCP_UDP_mode()
	
func _on_Deny_pressed():
	round_information_dict["Deny"] = true
	round_information_dict["Allow"] = false
	
	var result = check_if_correct_valid_packet(false)
	describe_what_happened()
	

func _on_Scan_pressed():
	
	
	var text_to_display = ""
	for constant in CPI_state:
		print(CPI_state)
		print(constant)
		var placement = CPI_state[constant]
		var info = current_packet_info[placement]
		var word = CPI_word_array[placement]
		
		text_to_display += "> " + word + " : " + info + " \n"	
	
	change_packet_info_text(text_to_display)
	


func describe_what_happened():
#	round_information_dict = { "Valid IP" : "", #was the packet valid or not?
#	"Deny" : "false", #did you deny it or not
#	"Allow" : {"TCP or UDP" : "UDP", #was it udp or tcp
#				"Successfully sent" : "false"}, #did it successfully send
#	"Correct choice" : "false"
#}
			#GET TY TO DO IT
			#essentially breaking down the dict and putting in a readable form
	
	var valid_ip = round_information_dict["Valid IP"]
	var deny = round_information_dict["Deny"]
	var allow = round_information_dict["Allow"]
	var correct = round_information_dict["Correct choice"]
	var what_text = ""
	
	if valid_ip == "true":
		what_text += "This was a Valid packet\n"
	else:
		what_text += "This was an Invalid packet\n"
	if deny == "true":
		what_text += "You denied this packet\n"
	else:
		what_text += "You allowed this packet\n"
	if allow == "true":
		var TCP_UDP = round_information_dict["Allow"]["TCP or UDP"]
		var successfullysent = round_information_dict["Allow"]["Successfully sent"]
		if TCP_UDP == "TCP":
			what_text+= "You used TCP\n"
	
	change_packet_info_text(what_text)
	ending_round()


func change_packet_info_text(text_to_display):
	var packet_info_text_nodepath = "CanvasLayer/Background/H/Right/CR/CR2/Info/TBody/Text"
	
	get_node(packet_info_text_nodepath).text = str(text_to_display)

func TCP_UDP_mode():
			#write down later what ty needs to do
	describe_what_happened()
	
	

func _on_RoundCheck_timeout():
	if is_a_round_happening == false:
		round_starter()
	
func ending_round():
			#waiting a few seconds for it to end
	$ProgressUp.stop()
	
	var timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()
	
	
	is_a_round_happening = false
			#GET SIR TO DO POINTS ADDY HERE

func round_starter():
			#first i needa get everything fresh and beautiful
			#then create a packet
			#uhhh dont think anything else agegagegagega
	is_a_round_happening = true
	current_packet_info = []
	
	change_packet_info_text("A new packet has arrived for you to check!")
	
	packet_creator()
	$ProgressUp.start()
	$CanvasLayer/Background/H/Right/CR/ProgressBar.value = 0
	
	


func _on_ProgressUp_timeout():
	$CanvasLayer/Background/H/Right/CR/ProgressBar.value += 1
	
	if $CanvasLayer/Background/H/Right/CR/ProgressBar.max_value == $CanvasLayer/Background/H/Right/CR/ProgressBar.value:
		ending_round()
		change_packet_info_text("Took too long. Packet was lost")
	
>>>>>>> Stashed changes
