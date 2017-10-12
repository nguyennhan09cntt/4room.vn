#require "axlsx"
require "csv"

class PostController < ApplicationController
  BOM = "\377\376"

  include ActionView::Helpers::TextHelper

  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 25).reorder("created_at DESC, id DESC")
    #send_xls(@post_list)
    date = DateTime.now
    
    #@begin_day = Date.new(date.year, date.month, date.day).in_time_zone('Hanoi') #Time.zone.name  #time_zone.local(date.year, date.month, date.day)
  end

  def export_data
    change_format
    zone = ActiveSupport::TimeZone.new('UTC')
    date = DateTime.now
    time_zone = Time.zone # any time zone really
    #begin_day = time_zone.local(date.year, date.month, date.day)
    begin_day = Date.new(date.year, date.month, date.day).in_time_zone('Hanoi')
    #begin_day = DateTime.now.beginning_of_day
    @post_list = Post.where('created_at > :created_time', {created_time: begin_day}).reorder("created_at DESC")
    content = @post_list.to_xls(col_sep: "\t")
    #content  = content.scrub('')
    respond_to do |format|
      format.html
      format.xls #{ send_data @post_list.to_xls(col_sep: "\t") }
    end
  end

  def update_data

    @user = current_user
    access_token = @user[:access_token]
    group_id = '545206412228291'
    facebook = Koala::Facebook::API.new(access_token)
    #   posts = facebook.get_object("#{group_id}/feed?limit=100")
    posts = facebook.get_connections(
      group_id,
      'feed', {
        limit: 100,
        fields: ['message', 'created_time', 'from', 'attachments']
      }
    )


    posts = posts.collect! do |fpost|
      post = {}
      unless  fpost['message'].blank?
        messages = fpost['message'].split("\n\n")
        if messages.length == 1
          post[:content] = messages[0].scrub if messages[0].present?
          #post[:content] = post[:content].gsub(/\n/, '<br/>').html_safe if post[:content].present?
        else
          part_one_array = messages[0].split("\n")
          post[:name] = part_one_array[0]
          if part_one_array[1]
            address_price = part_one_array[1].split(" - ")
            post[:price] = address_price[0].gsub!(/[^0-9]/, '')
            post[:price] = 0 if post[:price].to_i < 500000
            #post[:address] = address_price[1]
          end

          post[:content] = messages[1].scrub if messages[1].present?
          #post[:content] = post[:content].gsub(/\n/, '<br/>').html_safe if post[:content].present?
        end
      end

      post[:facebook_id] = fpost['id']
      post[:site_id] = 1
      post[:created_at] = fpost['created_time']

      member = {}
      if fpost['from'].present?
        member[:facebook_id] = fpost['from']['id']
        member[:name] = fpost['from']['name']

        member_record = Member.where('facebook_id = :facebook_id', {facebook_id: member[:facebook_id] })
        if member_record.present?
          post[:member_id] = member_record[0][:id]
        else
          member_record = Member.new(member)
          if member_record.save
            post[:member_id] = member_record[:id]
          end
        end
      end

      if post.present? && post[:content].present?
        post_record  = Post.where('facebook_id = :facebook_id', {facebook_id: post[:facebook_id]})
        if post_record.blank?
        	post = Post.new(post)
        	post.save
          if fpost['attachments'].present?
            attachments = fpost['attachments']['data'][0]

            if attachments.present?
              if attachments['type'] == 'album'
                attachments['subattachments']['data'].each do |image_attach|
                  if image_attach['type'] == 'photo'
                    image = {}
                    image[:name] = post[:name]
                    image[:post_id] = post[:id]
                    image[:url] = image_attach['media']['image']['src']
                    image_record = PostImage.new(image)
                    image_record.save
                    fpost[:image] = image
                  end
                end
              end

              if attachments['type'] == 'photo'
                image = {}
                image[:name] = post[:name]
                image[:post_id] = post[:id]
                image[:url] = attachments['media']['image']['src']
                image_record = PostImage.new(image)
                image_record.save
                fpost[:image] = image
              end
            end
          end
        end
      end

      post
    end
    redirect_to :action => 'index'
  end


  private
  def send_xls(post)
    book = Axlsx::Package.new
    workbook = book.workbook
    sheet = workbook.add_worksheet name: "StudentInformation"
    sheet.add_row [""]


    sheet.add_row ["Attributes", "Values"]

    create_data(post).each_with_index do |item|
      sheet.add_row(item[1..-1], types: Array.new(item.length, nil))
    end
    send_excel_file book
  end

  def send_excel_file(book)
    tmp_file_path = "#{Rails.root}/tmp/#{rand(36**50).to_s(36)}.xlsx"
    book.serialize tmp_file_path
    filename = "Xome_#{Time.zone.now}.xlsx"
    file_content = File.read(tmp_file_path)
    send_data file_content, filename: filename
    File.delete tmp_file_path
  end

  def create_data(post)
    [
      ["id", post[:id]],
      ["name", post[:name]],
      ["address", ""],
      ["district", ""],
      ["city", 'Ho Chi Minh'],
      ['description', ''],
      ['content', post[:content]],
      ['price', post[:price]],

    ]
  end

  def change_format
    request.format = "xls"
  end
end
