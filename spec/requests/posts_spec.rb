require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "/posts/new" do
    it "succeeds" do
      get new_post_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "posts/create" do
    def create_post(title, body)
      post posts_path, params: {
        post: {
          title: title,
          body: body 
        }
      }
    end

    context "valid params" do
      it "successfully creates a post" do
        expect do
          create_post("example title", "example body")
        end.to change { Post.count }.from(0).to(1)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "invalid params" do
      it "fails at creating the post" do
        expect { create_post("", "") }.not_to change { Post.count }
        expect(Post.count).to eq(0)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "/posts/:id for show" do
    let(:post) { create(:post) }

    context "when passing in valid post id" do
      it "succeeds" do
        get post_path(post)
        expect(response).to have_http_status(:success)
      end
    end

    context "when passing in invalid post id" do
      it "fails" do
        expect { get post_path("example text") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
