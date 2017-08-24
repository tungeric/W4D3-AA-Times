require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  def self.columns
    # ...
    return @columns if @columns
    cols = DBConnection.execute2(<<-SQL).first
    SELECT
      *
    FROM
      #{self.table_name}
    LIMIT 0
    SQL
    cols.map!(&:to_sym)
    @columns = cols
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        self.attributes[col]
      end

      define_method("#{col}=") do |value|
        self.attributes[col]=value
      end
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name || self.name.underscore.pluralize
  end

  def self.all
    # ...
    results = DBConnection.execute(<<-SQL)
      SELECT *
      FROM #{self.table_name}
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    # ...
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    # ..
    result = DBConnection.execute(<<-SQL, id)
      SELECT *
      FROM #{self.table_name}
      WHERE id = ?
    SQL
    self.parse_all(result).first
  end

  def initialize(params = {})
    # ...
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end

  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
    self.attributes.values
  end

  def insert
    # ...
    col_names = self.class.columns.drop(1).map(&:to_sym).join(",")
    question_marks = (["?"] * (self.class.columns.count-1)).join(",")
    DBConnection.execute(<<-SQL,*attribute_values)
      INSERT INTO #{self.class.table_name} (#{col_names})
      VALUES (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    # ...
    col_names = self.class.columns.drop(1).map(&:to_sym)
    set_line = col_names.map { |col| "#{col} = ?"}.join(",")
    att_values_no_id = attribute_values.drop(1)
    DBConnection.execute(<<-SQL,*att_values_no_id)
      UPDATE #{self.class.table_name}
      SET #{set_line}
      WHERE id = #{self.id}
    SQL

    # UPDATE
    #   table_name
    # SET
    #   col1 = ?, col2 = ?, col3 = ?
    # WHERE
    #   id = ?
  end

  def save
    # ...
    self.id.nil? ? insert : update
  end
end
