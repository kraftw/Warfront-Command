extends Node

func connect_signal(sender: Node, receiver: Node, signal_name: String) -> bool:
	if sender and receiver:
		var method_name = "_on_" + signal_name
		if receiver.has_method(method_name):
			sender.connect(signal_name, Callable(receiver, method_name))
			return true
		else:
			print("SignalHandler.connect_signal: receiver function does not exist: ", method_name)
			return false
	elif receiver:
		print("SignalHandler.connect_signal: sender is missing")
		return false
	elif sender:
		print("SignalHandler.connect_signal: receiver is missing")
		return false
	else:
		print("SignalHandler.connect_signal: sender and receiver are missing")
		return false
