class Default::MemberController < DefaultController	
	def index
		group_id = '545206412228291'
    if params[:group_id].present?
    	group_id = params[:group_id]
    end
    @site = Site.where('facebook_id = :group_id', {group_id: group_id}).first
    @members = Member.select('member.*').joins("LEFT JOIN `site_member` ON site_member.member_id = member.id").where('site_id = :site_id', {site_id: @site[:id]}).paginate(:page => params[:page], :per_page => 24)
    @filter = params.permit(:category, :price_value, :keyword)
	end

	def show
		 @member = Member.where('facebook_id = :facebook_id', {facebook_id: params[:member_id]}).first
	end
end
