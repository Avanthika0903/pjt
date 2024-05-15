# Example Puppet manifest file (print_message.pp)

# Define a class
class print_message {
  # Notify message
  notify { 'Hello, this is a test message!':
    # This message will be printed during Puppet execution
    message => 'Hello, this is a test message!',
  }
}

# Include the class
include print_message
