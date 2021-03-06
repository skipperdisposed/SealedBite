extends FSM_State

var state : int
var timer : float


func initialize():
	state = 0
	# dead animation
	obj.get_node( "anim" ).stop()
	
	#obj.get_node( "rotate/detect_player/detect_box" ).disabled = true
	obj.get_node( "collision" ).disabled = true
	obj.get_node( "damagebox/damage_collision" ).disabled = true
	if obj.find_node( "jumpbox" ):
		#print( "disabling jump" )
		obj.get_node( "jumpbox/jumpcollision" ).disabled = true
#		obj.get_node( "jumpbox" ).set_collision_mask_bit( 7, false )
#		obj.get_node( "jumpbox" ).set_collision_layer_bit( 7, false )
	obj.get_node( "hitbox/hitbox_collision" ).disabled = true
	obj.get_node( "rotate/slime_enemy" ).hide()
	timer = 0.5
	#game.camera_shake( 0.10, 60, 4, obj.hit_dir.normalized() )

	
	
	if randf() < game.heart_drop_rate():
		var h = preload( "res://props/heart/heart.tscn" ).instance()
		h.position = obj.position
		h.vel = -obj.hit_dir * 10
		obj.get_parent().add_child( h )


func run( delta ):
	if timer > 0:
		timer -= delta
	else:
		obj.position = obj.initial_position
		if not game.am_i_visible(obj, Vector2( 0, -4 )):
			fsm.state_nxt = fsm.states.run

func terminate():
	obj.get_node( "anim" ).play()
	obj.get_node( "collision" ).disabled = false
	obj.get_node( "damagebox/damage_collision" ).disabled = false
	if obj.find_node( "jumpbox" ):
		obj.get_node( "jumpbox/jumpcollision" ).disabled = false
#		obj.get_node( "jumpbox" ).set_collision_mask_bit( 7, true )
#		obj.get_node( "jumpbox" ).set_collision_layer_bit( 7, true )
	obj.get_node( "hitbox/hitbox_collision" ).disabled = false
	obj.get_node( "rotate/slime_enemy" ).show()
	obj.energy = 1
	obj.is_hit = false
	
	var x = preload( "res://enemies/explosion.tscn" ).instance()
	x.position = obj.position + Vector2( 0, -3 )
	x.modulate = Color( "e4d2aa" )
	# AGAIN: STUPID WAY TO SOLVE THIS!!!
	if obj.filename.find( "snow" ) != -1:
		x.modulate = Color( "e3e6ff" )
	elif obj.filename.find( "cave" ) != -1:
		x.modulate = Color( "df3e23" )
	obj.get_parent().add_child( x )
	