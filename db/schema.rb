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

ActiveRecord::Schema.define(version: 20150209035447) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "actions", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "count"
    t.string   "medium"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contributors", force: :cascade do |t|
    t.boolean  "is_admin"
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",  limit: 255
  end

  add_index "contributors", ["name"], name: "index_contributors_on_name", using: :btree
  add_index "contributors", ["remember_token"], name: "index_contributors_on_remember_token", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "access_code",     limit: 255
    t.integer  "recipient_id"
    t.integer  "inviter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "should_be_admin"
    t.boolean  "is_accepted"
  end

  add_index "invitations", ["access_code"], name: "index_invitations_on_access_code", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_tags", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "contributor_id"
    t.string   "image_url",          limit: 255
    t.string   "player_embed",       limit: 255
    t.string   "player_type",        limit: 255
    t.text     "download_link"
    t.string   "twitter_text",       limit: 255
    t.string   "facebook_text",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "is_deleted"
    t.text     "original_code"
  end

  add_index "posts", ["contributor_id"], name: "index_posts_on_contributor_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "ip_address",   limit: 255
    t.string   "session_code", limit: 255
    t.datetime "last_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_ranges", force: :cascade do |t|
    t.integer  "tagged_text_id"
    t.integer  "tag_id"
    t.integer  "start"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_ranges", ["tag_id"], name: "index_tag_ranges_on_tag_id", using: :btree
  add_index "tag_ranges", ["tagged_text_id"], name: "index_tag_ranges_on_tagged_text_id", using: :btree

  create_table "tagged_texts", force: :cascade do |t|
    t.string   "content_type", limit: 255
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tagged_texts", ["post_id"], name: "index_tagged_texts_on_post_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "description"
    t.integer  "contributor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag_type",       limit: 255
    t.boolean  "is_deleted"
  end

  add_index "tags", ["contributor_id"], name: "index_tags_on_contributor_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "session_id"
    t.boolean  "is_deleted"
    t.boolean  "is_upvote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
