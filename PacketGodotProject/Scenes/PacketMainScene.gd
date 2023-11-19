extends Node2D

enum CPI_state {SENDER_IP, DESTINATION_IP, PROTOCOL, WORD}


var rng = RandomNumberGenerator.new()

var current_packet_info = []
var CPI_word_array = ["Sender IP", "Destination IP", "Protocol", "Word"]
#"Sender IP", "Destiantion IP", "Protocol", "Word" 
#word is the keyword

var valid_ip_range = "100.10"
#100.10, 100, 100.10.1, for example
var num_valid_octets = 1

const BASE_ROUND_INFO_DICT = {
	"Valid IP" : "false", #was the packet valid or not?
	"Deny" : "false", #did you deny it or not
	"Allow" : {"TCP or UDP" : "UDP", #was it udp or tcp
				"Successfully sent" : "false"}, #did it successfully send
	"Correct choice" : "false"
}

var round_information_dict = {
	"Valid IP" : "", #was the packet valid or not?
	"Deny" : "false", #did you deny it or not
	"Allow" : {"TCP or UDP" : "UDP", #was it udp or tcp
				"Successfully sent" : "false"}, #did it successfully send
	"Correct choice" : "false"
}

#-------------------------------------------------
#Protocols will be a later want in thing
#GET TY TO CODE RELATED STUFF

var auto_invalid_protocols = []
#list of invalid porotocal that must be denied

var auto_valid_protocols = []
#list of valid protocols that must be allowed
#--------------------------------------------------

var keyword = "ookook"
#list of random words


func _ready():
	packet_creator()



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
	#GET TY TO DO IT
	#essentially breaking down the dict
	change_packet_info_text(round_information_dict)


func change_packet_info_text(text_to_display):
	var packet_info_text_nodepath = "CanvasLayer/Background/H/Right/CR/CR2/Info/TBody/Text"
	
	get_node(packet_info_text_nodepath).text = str(text_to_display)

func TCP_UDP_mode():
	#write down later what ty needs to do
	describe_what_happened()
	
	
