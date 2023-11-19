extends Node2D

enum CPI_state {SENDER_IP, DESTINATION_IP, PROTOCOL, WORD}


var rng = RandomNumberGenerator.new()

var current_packet_info = []
var CPI_word_array = ["Sender IP", "Destiantion IP", "Protocol", "Word"]
#"Sender IP", "Destiantion IP", "Protocol", "Word" 
#word is the keyword

var valid_ip_range = "100.10"
#100.10, 100, 100.10.1, for example
var num_valid_octets = 1


#-------------------------------------------------
#Protocols will be a later want in thing
#get ty to code related stuff to it

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
		if valid_ip_rng <= 80:
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


func check_if_correct_valid_packet():
	#first check sender ip, the destination ip
	var is_valid = true
	if (valid_ip_range in current_packet_info[CPI_state.SENDER_IP]) == false:
		is_valid = false
	
	if (valid_ip_range in current_packet_info[CPI_state.DESTINATION_IP]) == false:
		is_valid = false
	
	return is_valid
	
	
	
func _on_Allow_pressed():
	pass # Replace with function body.


func _on_Deny_pressed():
	pass # Replace with function body.


func _on_Scan_pressed():
	var packet_info_text_nodepath = "CanvasLayer/Background/H/Right/CR/CR2/Info/TBody/Text"
	
	var text_to_display = ""
	for constant in CPI_state:
		print(CPI_state)
		print(constant)
		var placement = CPI_state[constant]
		var info = current_packet_info[placement]
		var word = CPI_word_array[placement]
		
		text_to_display += "> " + word + " : " + info + " \n"	
	
	get_node(packet_info_text_nodepath).text = text_to_display




