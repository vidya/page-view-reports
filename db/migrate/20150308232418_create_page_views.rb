Sequel.migration do 
  change do

    create_table :page_views do
      primary_key :id
    end

  end
end