require_relative "../config/environment.rb"
require "pry"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students(id INTEGER PRIMARY KEY);
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students(name, grade) VALUES (?,?);
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?;
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
     student = Student.new(name, grade)
     student.save
     student
   end

   def self.new_from_db(row)
     new_student = Student.new(row[1],row[2],row[0])  # self.new is the same as running Song.new
     # self.name =  row[0]
     # new_student.grade = row[1]
     # new_student.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
     new_student  # return the newly created instance
   end

   def self.find_by_name(name)
     sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
     SQL

     row = DB[:conn].execute(sql, name).first
     self.new_from_db(row)
   end

end
