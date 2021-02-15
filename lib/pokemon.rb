class Pokemon
    attr_accessor :id, :name, :type, :db
    def initialize(attributes)
        attributes.each {|key, value| self.send(("#{key}="), value)}
    end

    def self.save(name, type, db)
        pokemon = self.new(name: name, type: type, db: db)
        pokemon.save
    end

    def save
        self.id != nil ? self.update_to_db : self.insert_to_db 
    end

    def insert_to_db
        sql = <<-SQL
            INSERT INTO pokemon (name, type)
            VALUES (?, ?);
        SQL
        self.db.execute(sql, self.name, self.type)
        self.id = self.db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
        self
    end

    def update_to_db
        sql = <<-SQL
            UPDATE pokemon
            SET name = ?, type = ?
            WHERE id = ?
        SQL
        self.db.execute(sql, self.name, self.type)
        self
    end

    def self.find(id,db)
        sql = <<-SQL
            SELECT * FROM pokemon
            WHERE id = ?
        SQL
        row = db.execute(sql, id)[0]
        self.new(id: row[0], name: row[1], type: row[2], db: db)
    end
end
