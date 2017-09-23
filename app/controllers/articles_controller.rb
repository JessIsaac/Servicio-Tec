class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user,except:[:index,:show]
  before_action :require_same_user,only:[:edit,:update,:destroy]
  def index
    @articles = Article.paginate(page: params[:page],per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
  @article = Article.new(article_params)
  @article.user = current_user
    if @article.save
      flash[:success] = "Article was successfully created"

      params1 = {"app_id" => "7472064f-567e-41b3-8ed6-7d5290c370d4",
          "contents" => {"en" => "English Message"},
          "included_segments" => ["All"]}
      uri = URI.parse('https://onesignal.com/api/v1/notifications')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path,
                                    'Content-Type'  => 'application/json;charset=utf-8',
                                    'Authorization' => "Basic NGEwMGZmMjItY2NkNy0xMWUzLTk5ZDUtMDAwYzI5NDBlNjJj")
      request.body = params1.as_json.to_json
      response = http.request(request)

      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def update
    @article.user = current_user
    if @article.update(article_params)
      flash[:success] = "Article was successfully updated"
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy
    @article.destroy
    flash[:danger] = "Article was successfully deleted"
    redirect_to articles_path
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description,:user_id,category_ids:[])
  end

  def require_same_user
    if current_user!= @article.user and !current_user.admin?
      flash[:danger] = 'You can only edit or delete your own articles'
      redirect_to root_path
    end
  end

end
