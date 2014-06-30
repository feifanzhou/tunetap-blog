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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140630161538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "contributors", force: true do |t|
    t.boolean  "is_admin"
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "contributors", ["name"], name: "index_contributors_on_name", using: :btree
  add_index "contributors", ["remember_token"], name: "index_contributors_on_remember_token", using: :btree

  create_table "invitations", force: true do |t|
    t.string   "access_code"
    t.integer  "recipient_id"
    t.integer  "inviter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "should_be_admin"
    t.boolean  "is_accepted"
  end

  add_index "invitations", ["access_code"], name: "index_invitations_on_access_code", using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.integer  "contributor_id"
    t.string   "image_url"
    t.string   "player_embed"
    t.string   "player_type"
    t.string   "download_link"
    t.string   "twitter_text"
    t.string   "facebook_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "posts", ["contributor_id"], name: "index_posts_on_contributor_id", using: :btree

  create_table "tag_ranges", force: true do |t|
    t.integer  "tagged_text_id"
    t.integer  "tag_id"
    t.integer  "start"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_ranges", ["tag_id"], name: "index_tag_ranges_on_tag_id", using: :btree
  add_index "tag_ranges", ["tagged_text_id"], name: "index_tag_ranges_on_tagged_text_id", using: :btree

  create_table "tagged_texts", force: true do |t|
    t.string   "content_type"
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tagged_texts", ["post_id"], name: "index_tagged_texts_on_post_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "contributor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag_type"
  end

  add_index "tags", ["contributor_id"], name: "index_tags_on_contributor_id", using: :btree

end
