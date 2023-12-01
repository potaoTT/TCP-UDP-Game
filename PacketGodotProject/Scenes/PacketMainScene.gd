extends Node2D

enum CPI_state {SENDER_IP, DESTINATION_IP, PROTOCOL, WORD}


var rng = RandomNumberGenerator.new()

var current_packet_info = []

var is_a_round_happening = false

var total_points_accumualted = 0

#-------------------------------------------------

var CPI_word_array = ["Sender IP", "Destination IP", "Protocol", "Word"]
		#"Sender IP", "Destiantion IP", "Protocol", "Word" 
		#word is the keyword
var valid_ip_range = "100.10"
		#100.10, 100, 100.10.1, for example
var num_valid_octets = 1

#-------------------------------------------------

const BASE_ROUND_INFO_DICT = {
	"Valid IP" : "false", #was the packet valid or not?
	"Deny" : "false", #did you deny it or not
	"Allow" : {"TCP or UDP" : "UDP", #was it udp or tcp
				"Successfully sent" : "false"}, #did it successfully send
	"Correct choice" : "false",
	"Scanned" : "false",
	"Lost" : "false"
}

var round_information_dict = {
	"Valid IP" : "", #was the packet valid or not?
	"Deny" : "false", #did you deny it or not
	"Allow" : {"TCP or UDP" : "UDP", #was it udp or tcp
				"Successfully sent" : "false"}, #did it successfully send
	"Correct choice" : "false",
	"Scanned" : "false",
	"Lost" : "false"}

#-------------------------------------------------
		#Protocols will be a later want in thing
		#GET TY TO CODE RELATED STUFF
var protocols = [
	"SMTP",
	"ICMP",
	"FTP",
	"HTTPS",
	"DHCP"]

var auto_invalid_protocols = []
		#list of invalid porotocal that must be denied

var auto_valid_protocols = []
		#list of valid protocols that must be allowed
#-------------------------------------------------

#do code for this later
var keyword = "ookook"
		#list of random words

#-------------------------------------------------

signal TCP_UDP_end 

func _ready():
	print("start")
	start_round()
	$CanvasLayer/ALERT.visible = true
	$CanvasLayer/ALERT/textbcknd/Label.text = "WAITING FOR A NEW PACKET..."

func start_round():
	$RoundCheck.start(1)
	$RoundCheck.wait_time = 5
	#code to check if server is online
	is_a_round_happening = false


func packet_creator():
	current_packet_info = []
	
	
	while len(current_packet_info) != 2:
		var valid_ip_rng = rng.randi_range(1, 100)
		
		var ip_starter = null
		if valid_ip_rng <= 65:
			ip_starter = valid_ip_range
		else:
			var ip_first = rng.randi_range(120,255)
			var ip_second = rng.randi_range(1,255)
			ip_starter = str(ip_first) + "." + str(ip_second)
	
			
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
	
	
	var max_num = len(protocols) - 1
	
	var rng_for_protocol = rng.randi_range(0, max_num)
	current_packet_info.append(protocols[rng_for_protocol])
	current_packet_info.append(keyword)
	print(current_packet_info)

func hacker_is_in(hacker_ip):
	ending_round(true)
	is_a_round_happening = true
	round_starter(true)
	hacker_packet(hacker_ip)
	

func hacker_packet(hacker_ip):
	current_packet_info = [""]
	current_packet_info.append(str(hacker_ip))
	
	current_packet_info.append(str("Your IP"))
	
	current_packet_info.append("Hacked")
	current_packet_info.append(keyword)

func check_if_correct_valid_packet(allowed):
			#first check sender ip, the destination ip
	var is_valid = true
	if (valid_ip_range in current_packet_info[CPI_state.SENDER_IP]) == false:
		is_valid = false
	
	if (valid_ip_range in current_packet_info[CPI_state.DESTINATION_IP]) == false:
		is_valid = false
	
	round_information_dict["Valid IP"] = (str(is_valid)).to_lower()
	
	
			#false = false, good, true = true, good, 
	var correct_action = false
	
	if is_valid == allowed:
				#means that either a good packet was accept or a bad one was denied
		correct_action = "true"
	else:
				#means that either a good packet was denied or a bad one was accepted
		correct_action = "false"
	
			#this will earn the player some points (majority)
	
	round_information_dict["Correct choice"] = (str(correct_action)).to_lower()
	
	
	return correct_action
	
func point_giver():
	pass
	
func _on_Allow_pressed():
	round_information_dict["Deny"] = "false"
	round_information_dict["Allow"] = BASE_ROUND_INFO_DICT["Allow"]
	
	var result = check_if_correct_valid_packet(true)
	
	TCP_UDP_mode()
	
func _on_Deny_pressed():
	round_information_dict["Deny"] = "true"
	round_information_dict["Allow"] = "false"
	
	var result = check_if_correct_valid_packet(false)
	describe_what_happened()
	

func _on_Scan_pressed():
	$ProgressUp.stop()
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Scan.text = "> Scanning..."
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Deny.disabled = true
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Allow.disabled = true
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Scan.disabled = true
	
	round_information_dict["Scanned"] = "true"
	
	var random_wait = rng.randf_range(0.8,2.2)
	var timer = Timer.new()
	timer.set_wait_time(random_wait)
	print(random_wait)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Deny.text = "> Scanning..."
	timer.start()
	yield(timer, "timeout")
	
	random_wait = rng.randf_range(0.8,2.2)
	print(random_wait)
	timer.set_wait_time(random_wait)
	
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Allow.text = "> Scanning..."
	timer.start()
	yield(timer, "timeout")
	
	random_wait = rng.randf_range(0.8,2.2)
	print(random_wait)
	timer.set_wait_time(random_wait)
	
	timer.start()
	yield(timer, "timeout")
	
	timer.queue_free()
	
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Scan.text = "> Scan Packet"
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Deny.text = "> Deny Packet"
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Allow.text = "> Allow Packet"
	
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Deny.disabled = false
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Allow.disabled = false
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Scan.disabled = false
	$ProgressUp.start()

	
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
	var valid_ip = round_information_dict["Valid IP"]
	var deny = round_information_dict["Deny"]
	var allow = round_information_dict["Allow"]
	var correct = round_information_dict["Correct choice"]
	var scanned = round_information_dict["Scanned"]
	var what_text = ""
	
	print(valid_ip)
	if str(valid_ip).to_lower() == "true":
		what_text += "This was a Valid packet\n"
	else:
		what_text += "This was an Invalid packet\n"
	
	if scanned == "true":
		what_text += "You scanned the packet\n"
	else:
		what_text += "You didn't scan the packet\n"
		
	if deny == "true":
		what_text += "You denied this packet\n"
	else:
		what_text += "You allowed this packet\n"
		var TCP_UDP = round_information_dict["Allow"]["TCP or UDP"]
		var successfullysent = round_information_dict["Allow"]["Successfully sent"]
		if TCP_UDP == "TCP":
			what_text += "You used TCP\n"
		else:
			what_text += "You used UDP\n"
			if successfullysent == "false":
				what_text += "But it was unsuccessfully sent"
			else:
				what_text += "And it was successfully sent"
	if correct == "true":
		what_text += "This was the correct choice"
	else:
		what_text += "This was the wrong choice"
	change_packet_info_text(what_text)
	ending_round()


func change_packet_info_text(text_to_display):
	var packet_info_text_nodepath = "CanvasLayer/Background/H/Right/CR/CR2/Info/TBody/Text"
	
	get_node(packet_info_text_nodepath).text = str(text_to_display)

func TCP_UDP_mode():
			#write down later what ty needs to do
			#actually i'll do this cause it'd be hard for Ty
	$CanvasLayer/Background/H/Middle/TCPUDP.visible = true
	
	yield(self, "TCP_UDP_end")
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/TCP.visible = true
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/UDP.visible = true
	
	describe_what_happened()
	
	

func _on_TCP_pressed(): #take care of the baby
	$ProgressUp.stop()
	round_information_dict["Allow"]["TCP or UDP"] = "TCP"
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/TCP.visible = false
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/UDP.visible = false
	
			#FUNCTION FLESH
	var text_to_display = [
		"\n> Sending the packet...", " Successfully sent! \n",
		"> Unpacking the packet...", " Successfully unpacked! \n"
	]
	
	for text in text_to_display:
		
		
		var random_wait = rng.randf_range(0.75,1.5)
		print(random_wait)
		if text != text_to_display[0] or text != text_to_display[2]:
			$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/Text.text += text
		
		var timer = Timer.new()
		timer.set_wait_time(random_wait)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		timer.queue_free()
		
		
	round_information_dict["Allow"]["Successfully sent"] = "true"
	emit_signal("TCP_UDP_end")
	
	
	
	
func _on_UDP_pressed(): #yeet the baby
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/TCP.visible = false
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/UDP.visible = false
	round_information_dict["Allow"]["TCP or UDP"] = "UDP"
	
			#FUNCTION FLESH
	var did_it_send = rng.randi_range(1,6)
	
	if did_it_send == 3:
		round_information_dict["Allow"]["Successfully sent"] = "true"
	else:
		round_information_dict["Allow"]["Successfully sent"] = "false"
	
	
	emit_signal("TCP_UDP_end")


func _on_RoundCheck_timeout():
	if is_a_round_happening == false:
		$CanvasLayer/ALERT.visible = false
		round_starter()
		
	
func ending_round(hacker=false):
			#waiting a few seconds for it to end
	$ProgressUp.stop()
	
	
	
	
	
	var points_earned = point_calculations()
	
	round_information_dict = BASE_ROUND_INFO_DICT
	
	$CanvasLayer/Background/H/Left/Info/TBody/Text.text = "> Points earned : " + str(points_earned) + "\n"
	$CanvasLayer/Background/H/Left/Info/TBody/Text.text += "> Total points earned : " + str(total_points_accumualted)
	$CanvasLayer/Background/H/Middle/TCPUDP.visible = false
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/Text.text = "some random text about TCP and UDP"
			
	
	if hacker == true:
		_on_ProgressUp_timeout()
	
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Allow.disabled = true
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Deny.disabled = true
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Scan.disabled = true
			#GET SIR TO DO POINTS ADDY HERE
	
	$StartingConnections._sending_points(points_earned)
	
	var timer = Timer.new()
	timer.set_wait_time(2.5)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")

	$CanvasLayer/ALERT.visible = true
	$CanvasLayer/ALERT/textbcknd/Label.text = "WAITING FOR A NEW PACKET..."
	timer.start()
	yield(timer, "timeout")
	
	timer.queue_free()
	round_information_dict = BASE_ROUND_INFO_DICT
	is_a_round_happening = false
	

	


func round_starter(hacker=false):
			#first i needa get everything fresh and beautiful
			#then create a packet
			#uhhh dont think anything else agegagegagega
	$CanvasLayer/Background/H/Middle/TCPUDP.visible = false
	
	$CanvasLayer/Background/H/Middle/TCPUDP/TBody/V/Text.text = "some random text about TCP and UDP"
	
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Allow.disabled = false
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Deny.disabled = false
	$CanvasLayer/Background/H/Middle/Action/TBody/V/Scan.disabled = false
	
	is_a_round_happening = true
	current_packet_info = []
	
	change_packet_info_text("A new packet has arrived for you to check!")
	
	if hacker == false:
		packet_creator()
		$ProgressUp.start()
	$CanvasLayer/Background/H/Right/CR/ProgressBar.value = 0
	

func _on_ProgressUp_timeout():
	$CanvasLayer/Background/H/Right/CR/ProgressBar.value += 1
	
	if $CanvasLayer/Background/H/Right/CR/ProgressBar.max_value == $CanvasLayer/Background/H/Right/CR/ProgressBar.value:
		round_information_dict["Lost"] = "true"
		ending_round()
		change_packet_info_text("Took too long. Packet was lost")
	

func point_calculations():
	var points = 0
	var rid = round_information_dict
	print(rid)
	
	if rid["Lost"] == "false":
		if rid["Correct choice"] == "false":
			points = -2
		else:
			points = 1
			if rid["Scanned"] == "true":
				points += 1
			
			if rid["Deny"] == "true":
				points += 0
			else: #allow
				if rid["Allow"]["Successfully sent"] == "false":
					points = 0
				else:
					if rid["Allow"]["TCP or UDP"] == "TCP":
						points += 1
				
	else:
		points = -1
	
	print("points")

	total_points_accumualted += points
	
	print(points)
	return points


