class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_role

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        @post.set_position
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /switch/1/2
  def switch
    first = Post.find(params[:first])
    second = Post.find(params[:second])

    first.switch second

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  # PATCH/PUT /switch/1
  def switch_with_next
    first = Post.find(params[:first])
    second = first.next

    if first.next.present?
      first.switch second
    end

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  # PATCH/PUT /switch/2
  def switch_with_prev
    first = Post.find(params[:first])
    second = first.prev

    if first.prev.present?
      first.switch second
    end

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  # PATCH/PUT /feature/1
  def feature
    post = Post.find(params[:id])
    post.featured!

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  # PATCH/PUT /defeature/1
  def defeature
    post = Post.find(params[:id])
    post.defeature!

    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :user, :main, :featured, :position, :tag_list)
    end

    def check_role
      redirect_to root_path, notice: 'Ты ещё слишком молод для этого.' if current_user.newbie?

      if (params[:action] == 'new' || params[:action] == 'create' || params[:action] == 'destroy') && current_user.corrector?
        redirect_to posts_url, notice: 'Ты не можешь создавать новый контент.'
      end

      if (params[:action] == 'update' || params[:action] == 'edit' || params[:action] == 'destroy') && current_user.author? && current_user.id != @post.user.id
        redirect_to posts_url, notice: 'Ты не можешь менять чужой контент.'
      end
    end
end
