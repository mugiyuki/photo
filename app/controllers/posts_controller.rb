class PostsController < ApplicationController
  # アクション処理に入る前に認証
  before_action :authorize
  # 新規投稿ページ
  def new
    @post = Post.new
  end
  # 投稿処理
  def create
    @post = Post.new(post_params)
    upload_file = params[:post][:upload_file]
    # 投稿画像がない場合
    if upload_file.blank?
    flash[:danger] = "投稿には画像が必須です。"
    redirect_to new_post_path and return
    end
    upload_file_name = upload_file.original_filename
    output_dir = Rails.root.join('public', 'images')
    output_path = output_dir + upload_file_name
    File.open(output_path, 'w+b') do |f|
    f.write(upload_file.read)
    end
    # post_imagesテーブルに登録するファイル名をPostインスタンスに格納
    @post.post_images.new(name: upload_file_name)
    # データベースに保存
    if @post.save
      # 成功
      flash[:danger] = "投稿しました。"
      redirect_to top_path
    else
      flash[:danger] = "投稿には画像が必須です。"
    redirect_to new_post_path and return
    end
  end
  
  # 投稿を削除
  def destroy
    # ここに処理を実装
    # 投稿を取得
    @post = Post.find(params[:id])
    @post.destroy
    if @post.destroy
      flash[:danger] = "投稿を削除しました。"
      redirect_to top_path
    else   flash[:danger] = "投稿を削除しました。"
      redirect_to top_path
    end
  end
  # いいね処理
  def like
    # ここに処理を実装
    @post = Post.find(params[:id])
    if PostLike.exists?(post_id: @post.id, user_id: current_user.id)
      # いいねを削除(上記)
      PostLike.find_by(post_id: @post.id, user_id: current_user.id).destroy
      redirect_to top_path
    else
      # いいねを登録
      PostLike.create(post_id: @post.id, user_id: current_user.id)
      redirect_to top_path
    end
  end
  
  # コメント用パラメータを取得
  def post_comment_params
    params.require(:post_comment).permit(:comment).merge(user_id: current_user.id)
  end
  # コメント投稿処理
  def comment
    # 投稿IDを受け取り、投稿データを取得
    @post = Post.find(params[:id])
   
    # コメント保存
    @post.post_comments.create(post_comment_params)
    redirect_to top_path
  end
  
  
  private
  def post_params
    params.require(:post).permit(:caption).merge(user_id: current_user.id)
  end
end
