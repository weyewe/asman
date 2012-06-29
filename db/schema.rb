# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120627070513) do

  create_table "assets", :force => true do |t|
    t.string   "asset_no"
    t.integer  "creator_id"
    t.integer  "client_id"
    t.integer  "machine_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "assignments", :force => true do |t|
    t.integer  "role_id"
    t.integer  "job_attachment_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "contact_person"
    t.string   "phone_number"
    t.string   "blackberry_pin"
    t.string   "email"
    t.string   "address"
    t.integer  "creator_id"
    t.integer  "office_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "compatibilities", :force => true do |t|
    t.integer  "spare_part_id"
    t.integer  "component_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "component_categories", :force => true do |t|
    t.string   "name"
    t.integer  "office_id"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "component_statuses", :force => true do |t|
    t.integer  "maintenance_id"
    t.integer  "component_id"
    t.boolean  "status"
    t.text     "description"
    t.integer  "replacement_spare_part_id"
    t.integer  "creator_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "components", :force => true do |t|
    t.string   "name"
    t.integer  "machine_id"
    t.integer  "creator_id"
    t.integer  "component_category_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "job_attachments", :force => true do |t|
    t.integer  "office_id"
    t.integer  "user_id"
    t.boolean  "is_active",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "machine_categories", :force => true do |t|
    t.string   "name"
    t.integer  "office_id"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "machines", :force => true do |t|
    t.string   "model_name"
    t.integer  "machine_category_id"
    t.integer  "office_id"
    t.integer  "creator_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "maintenances", :force => true do |t|
    t.string   "work_order_no"
    t.integer  "creator_id"
    t.integer  "asset_id"
    t.integer  "office_id"
    t.boolean  "is_finalized",           :default => false
    t.integer  "finalizer_id"
    t.text     "invoice_url"
    t.datetime "finalization_datetime"
    t.boolean  "is_paid",                :default => false
    t.integer  "payment_approver_id"
    t.text     "payment_receipt_url"
    t.string   "payment_receipt_number"
    t.datetime "payment_datetime"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "offices", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "prices", :force => true do |t|
    t.decimal  "amount",        :precision => 11, :scale => 2, :default => 0.0
    t.integer  "creator_id"
    t.integer  "spare_part_id"
    t.boolean  "is_active"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  create_table "profiles", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spare_parts", :force => true do |t|
    t.string   "part_code"
    t.integer  "office_id"
    t.integer  "creator_id"
    t.integer  "component_category_id"
    t.boolean  "is_active",             :default => true
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
