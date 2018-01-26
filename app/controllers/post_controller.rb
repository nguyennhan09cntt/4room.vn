#require "axlsx"
require "csv"
require_relative '../../lib/utils'

class PostController < ApplicationController
  BOM = "\377\376"

  include ActionView::Helpers::TextHelper

  def index
  	group_id = '545206412228291'
    if params[:group_id].present?
    	group_id = params[:group_id]
    end
    @site = Site.where('facebook_id = :group_id', {group_id: group_id}).first
    @posts = Post.where('site_id = :site_id', {site_id: @site[:id]}).paginate(:page => params[:page], :per_page => 25).reorder("created_at DESC, id DESC")
    #send_xls(@post_list)
    #date = DateTime.now

    #@begin_day = Date.new(date.year, date.month, date.day).in_time_zone('Hanoi') #Time.zone.name  #time_zone.local(date.year, date.month, date.day)
  end

  def export_data    
    group_id = '545206412228291'
    if params[:group_id].present?
      group_id = params[:group_id]
    end

    date_from = params['date-from']
    date_to = params['date-to']
    change_format
    #zone = ActiveSupport::TimeZone.new('UTC')
    date = DateTime.now.beginning_of_day
    if date_from.present?
      date = DateTime.strptime(date_from, '%d/%m/%Y').beginning_of_day
    end
    #time_zone = Time.zone # any time zone really
    #begin_day = time_zone.local(date.year, date.month, date.day)
    begin_date = date#.in_time_zone('UTC')
    date = DateTime.now.end_of_day
    if date_to.present?
      date = DateTime.strptime(date_to, '%d/%m/%Y').end_of_day
    end
    end_date = date#.in_time_zone('UTC')

    @site = Site.where('facebook_id = :group_id', {group_id: group_id}).first

    #begin_day = DateTime.now.beginning_of_day
    @post_list = Post.where(
      'created_at > :begin_date and created_at < :end_date AND site_id = :site_id',
      {begin_date: begin_date, end_date: end_date, site_id: @site[:id]}
    ).reorder("created_at DESC")
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
    if params[:group_id].present?
    	group_id = params[:group_id]
    end
    
    site = Site.where('facebook_id = :group_id', {group_id: group_id}).first
    return if site.blank?

    facebook = Koala::Facebook::API.new(access_token)
    #   posts = facebook.get_object("#{group_id}/feed?limit=100")
    posts = facebook.get_connections(
      group_id,
      'feed', {
        limit: 100,
        fields: ['message', 'created_time', 'from', 'attachments']
      }
    )

    # if site[:id] !=1
    # 	msg = { :status => "ok", :message => "Success!", :html =>posts }
    # 	render :json => msg
    # 	return
    # end

    posts = posts.collect! do |fpost|
      post = {}
      unless  fpost['message'].blank?
        messages = fpost['message'].split("\n\n")
        if messages.length == 1
          post[:content] = messages[0].scrub if messages[0].present?

          part_one_array = messages[0].split("\n")
          if part_one_array.length > 1 
          	messages[0] = part_one_array[0]
          end
          
          post[:name] = messages[0].split(' ').first(16).join(' ').each_char.select { |char| char.bytesize < 4 }.join if messages[0].present?
          post[:name] = post[:name] + '...' if post[:name].present?
        else
          part_one_array = messages[0].split("\n")
          post[:name] = part_one_array[0].each_char.select { |char| char.bytesize < 4 }.join if part_one_array[0].present?
          post[:name] = post[:name].split(' ').first(16).join(' ').each_char.select { |char| char.bytesize < 4 }.join if post[:name].present?
          post[:name] = post[:name] + '...' if post[:name].present?

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

      post[:uid] = Post.random_uid(site[:uid])
      post[:facebook_id] = fpost['id']
      post[:site_id] = site[:id]
      post[:status] = 2
      post[:created_at] = DateTime.parse(fpost['created_time']) + 7.hours

      post_record  = Post.where('facebook_id = :facebook_id', {facebook_id: post[:facebook_id]})
      next if post_record.present?

      member = {}
      if fpost['from'].present?
        member[:facebook_id] = fpost['from']['id']
        member[:name] = fpost['from']['name']
        member[:uid] = Member.random_uid
        
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
                  image[:post_uid] = post[:uid]
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
              image[:post_uid] = post[:uid]
              image[:post_id] = post[:id]
              image[:url] = attachments['media']['image']['src']
              image_record = PostImage.new(image)
              image_record.save
              fpost[:image] = image
            end
          end
        end
      end

      post
    end
    redirect_to :action => 'index'
  end

  def update_status
    status = params[:staus]
    ids = params[:ids]
    Post.where(:id => ids).update_all(:status => status)
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
