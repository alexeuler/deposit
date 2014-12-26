class CreateDeposit < ActiveRecord::Migration
  def change
    create_table 'deposits', force: true do |t|
      t.integer 'website_id', null: false
      t.string 'title'
      t.string 'bank'
      t.float 'rate'
      t.float 'term'
      t.integer 'min'
      t.string 'special_deposit'
      t.string 'special_terms'
      t.string 'refill_status'
      t.string 'refill_warning'
      t.string 'refill_message'
      t.timestamps
    end
  end
end
