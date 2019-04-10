require 'pry'

class Dog

  attr_accessor :id, :name, :breed

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create(hash)
    new_dog = Dog.new(name: hash[:name], breed: hash[:breed])
    new_dog.save
  end

  def self.create_table
    DB[:conn].execute('CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)')
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE dogs')
  end

  def self.find_by_id(id)
    new_from_db(DB[:conn].execute('SELECT * FROM dogs WHERE id = ?', [id]).flatten)
  end

  def self.new_from_db(data_array)
    Dog.new(id: data_array[0], name: data_array[1], breed: data_array[2])
  end

  def self.find_or_create_by(name: ,breed: )
    if !DB[:conn].execute('SELECT * FROM dogs WHERE name = ? AND breed = ?', [name, breed]).flatten.empty?
      Dog.new_from_db(DB[:conn].execute('SELECT * FROM dogs WHERE name = ? AND breed = ?', [name, breed]).flatten)
    else
      Dog.create(name: name, breed: breed)
    end
  end

  def self.find_by_name(name)
    new_from_db(DB[:conn].execute('SELECT * FROM dogs WHERE name = ?', [name]).flatten)
  end

  def update
    DB[:conn].execute('UPDATE dogs SET name = ? WHERE id = ?', [self.name, self.id])
  end

  def save
    DB[:conn].execute("INSERT INTO dogs (name, breed) VALUES (?, ?)", [self.name, self.breed])
    self.id = DB[:conn].execute('SELECT * FROM dogs WHERE name = ? AND breed = ?', [self.name, self.breed]).flatten[0]
    self
  end

end
