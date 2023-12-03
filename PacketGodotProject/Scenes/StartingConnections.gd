extends Node


const PORT : int = 9876

var client = WebSocketClient.new()
var URL: String = "ws://same.ip.as.connecting:%s" % PORT

var server_id


var settings_file = "res://client_settings.txt"

var user = ""
var team = ""
var addr = ""
var port = ""
var head = ""
var role = ""
var terminal = 'game'

var settings = {}

func _extract_from_client_settings():
	var file = File.new()
	file.open(settings_file, File.READ)
	
	
	while not file.eof_reached():
		
		var split = (file.get_line().split(":"))
		print("extracting..." + str(split))
		settings[split[0]] = split[-1]
		
		match split[0]:
			"user":
				user = split[1]
			"team":
				team = split[1]
			"role":
				role = split[1]
			"addr":
				addr = split[1]
			"head":
				head = split[1]
			"port":
				port = split[1]
	file.close()

func _ready() -> void:
	print("started")
	
	
	_client_settings_locate_change()
	_extract_from_client_settings()
	print("connecty testy")
	
	client.connect("connection_closed", self, "_closed")
	client.connect("connection_error", self, "_closed")
	client.connect("connection_established", self, "_connected")
	client.connect("data_received", self, "_on_data")
	print("we no likey testy")
	
	var better_url = "ws://%s:%s" % [addr, port]  
	print(better_url)
	
	var err = client.connect_to_url(better_url)
	
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		print("Okay!")
	
#either grabs client settings from within the file
#or outside
func _client_settings_locate_change():
	#C:\Users\joshd\Desktop\CompSciProject\TCP-UDP-Game\PacketGodotProject
	settings_file
	
	var settings_file_locate = ""
	#means it is in godot
	if (OS.has_feature("standalone")) == false:
		settings_file_locate = ProjectSettings.globalize_path(settings_file)
	else:
		#the exe SHOULD be in the clients folder of the thingo launcher
		#so technically, this should would cause the .exe and settings will be in the same folder
		#if it doesn't, I will murder you cause it is meant to be working
		#so computer, I am threatening you, work
		var directory = OS.get_executable_path().get_base_dir()
		
		settings_file_locate = directory + "/client_settings.txt"
	
	settings_file = settings_file_locate
	print(settings_file)


func _closed():
	print("closed")

#godot has flexible type
#this creates more risky code
#the void returns a void if the protocol isnt a string
func _connected(protocol: String) -> void:
	print("connecty")
	var message = ("join:" + user + "|" + team + "|" + role + "|" + terminal + "|" + head)
	
	#first creating the packet as utf
	#sends it off
	
	var packet: PoolByteArray = message.to_utf8()
	client.get_peer(1).put_packet(packet)
	
func _process(_delta: float) -> void:
	client.poll()
	
func _on_data() -> void:
	var pkt = client.get_peer(1).get_packet()
	var incoming = pkt.get_string_from_utf8()
	print('Server says : ' + incoming)
	
	var splitted_incomming = incoming.split(":")
	
	
	
	match splitted_incomming[0]:
		"YOU ARE BEING DOS ATTACKED":
			#create timer child with pause mode process
			#pause the child
			#attach script to child
			#on self timeout, 
			get_parent().get_node("DOSChild").start()
			get_parent().get_node("CanvasLayer/ALERT").visible = true
			get_parent().get_node("CanvasLayer/ALERT/textbcknd/Label").text = "YOU GOT DOSSED! YOU WON'T BE ABLE TO PLAY FOR 10 SECONDS"
			get_parent().paused = true
		"hacker": #hacker:IP
			#DO AS VERY LAST THING
			#psuedocode as will do later
			#end current round 
			#wait 2 seconds
			#time out the current timer
			#create the packet but with the procol being a hacker
			#deny the packet kicks the person off
			pass
		"test":
			if splitted_incomming[1] == "False":
				get_parent().start_round()
				get_parent().get_node("serverSecondCheck").stop()
			
	
	
func _sending_points(points):
	var message = "game:add_points|%s" % points
	
	#first creating the packet as utf
	#sends it off
	
	var packet: PoolByteArray = message.to_utf8()
	client.get_peer(1).put_packet(packet)


func _yeeting_someone(hacker_ip):
	var message = "yeet:%s" % hacker_ip
	var packet: PoolByteArray = message.to_utf8()
	client.get_peer(1).put_packet(packet)
	
func _intel(taking):
	var message = "yeet:%s" % taking
	var packet: PoolByteArray = message.to_utf8()
	client.get_peer(1).put_packet(packet)
	


func _sending_test():
	var packet_to_send = "test:"
	
	#var contents = role_file.get_as_text()
	#print(contents)
	
	packet_to_send += team + ":" + user
	print(packet_to_send)
	
	client.get_peer(1).put_packet(packet_to_send.to_utf8())


func _on_serverSecondCheck_timeout():
	_sending_test()
	
