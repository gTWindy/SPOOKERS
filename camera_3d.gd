extends Camera3D
# Время колебаниям камеры
var shake_time = 0.7
# Таймер для покачивания
var timer = 0
# Таймер для начала покачивания
var timer_begin_shake = 0
var time_without_shake = 1.2

# Амплитуда колебаний камеры
var amplitude_x = 0.2
var amplitude_y = 0.1
# Ускорение
var acceleration = 0

# Начальная позиция камеры
var initial_camera_pos

func _ready():
	# Запоминаем начальную позицию камеры
	initial_camera_pos = transform.origin

func _physics_process(delta):
	if (timer_begin_shake < time_without_shake):
		timer_begin_shake += delta
		return
	
	# Обновляем таймер
	if timer > 0:
		timer -= delta
	# Получаем ввод от игрока
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Покачиваем камеру, если персонаж движется
	if direction.length() > 0:
		if (acceleration < 1):
			acceleration += 0.001
		shake_camera(acceleration)
	else:
		acceleration = 0
		transform.origin = initial_camera_pos
		timer_begin_shake = 0

func shake_camera(delta):
	# Если таймер истек, начинаем новое колебание
	if timer <= 0:
		timer = shake_time
		
	# Рассчитываем новые координаты камеры
	#var new_x = sin(timer / 2*shake_time * 2 * PI) * amplitude_x
	var new_y = sin(timer / shake_time * 2 * PI) * amplitude_y
	# Применяем колебания к камере
	transform.origin = initial_camera_pos + Vector3(0, new_y, 0)
