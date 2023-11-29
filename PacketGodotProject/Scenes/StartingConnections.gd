extends Node


const PORT : int = 9876

var client = WebSocketClient.new()
var URL: String = "ws://localhost:%s" % PORT

var server_id

func _ready() -> void:
	print("connecty testy")
	client.connect_to_url(URL)
	client.connect("connection_closed", self, "_closed")
	client.connect("connection_error", self, "_closed")
	client.connect("connection_established", self, "_connected")
	client.connect("data_received", self, "_on_data")
	print("we no likey testy")
	
		#come back to later
	
	#add connection 

func _closed():
	print("closed")

#godot has flexible type
#this creates more risky code
#the void returns a void if the protocol isnt a string
func _connected(protocol: String) -> void:
	print("no connecty")
	var message = "||:GodotKid"
	
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
		
	
	
func _sending_points(points):
	var message = "score:%s" % points
	
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
	
	


	
