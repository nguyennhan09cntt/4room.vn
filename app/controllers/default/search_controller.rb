class Default::SearchController < DefaultController

  def index
    @posts = where_condition(params[:category], params[:price_value], params[:keyword]).paginate(:page => params[:page], :per_page => 6)
    @filter = params.permit(:category, :price_value, :keyword)
  end

  private
  def where_condition(category_identify, price_value, keyword)
    @posts = Post.select('id', 'facebook_id', 'content')

    if category_identify.present?
      category = Category.where('identify = :category_identify', {category_identify: category_identify}).first
      category_ids =  Category.where('parent_id IN (:category_id) OR id IN (:category_id)', {category_id: category[:id]}).map(&:id)

      @posts = @posts.joins('LEFT JOIN site ON site.id = post.site_id')
      .where('site.category_id IN (:category_id)', {category_id: category_ids})
    end

    if price_value.present?
      price_value = price_value.to_i
      case price_value
      when 1
        @posts = @posts.where('post.price < 1000000')
      when 2
        @posts = @posts.where('post.price >= 1000000 AND post.price < 3000000')
      when 3
        @posts = @posts.where('post.price >= 3000000 AND post.price < 5000000')
      when 4
        @posts = @posts.where('post.price >= 5000000 AND post.price < 10000000')
      when 5
        @posts = @posts.where('post.price >= 10000000')
      end
    end

    if keyword.present?
      @posts = @posts.where('post.content LIKE :keyword', keyword: "%#{keyword}%")
    end
    @posts.order("post.created_at DESC, post.id DESC")
  end
end
