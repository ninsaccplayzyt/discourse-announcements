# frozen_string_literal: true

after_initialize do
  module ::Announcements
    class AdminAnnouncementsController < ::ApplicationController
      requires_plugin Announcements

      before_action :ensure_admin

      def index
        render json: { announcements: Announcement.all }
      end

      def create
        announcement = Announcement.new(content: params[:content])
        if announcement.save
          render json: { message: "Announcement created successfully." }
        else
          render json: { error: "Failed to create announcement." }, status: :unprocessable_entity
        end
      end
    end

    class Announcement < ActiveRecord::Base
      validates :content, presence: true
    end
  end

  ::Announcements::Engine.routes.draw do
    get "/admin/plugins/announcements" => "admin_announcements#index"
    post "/admin/plugins/announcements" => "admin_announcements#create"
  end

  Discourse::Application.routes.append do
    mount ::Announcements::Engine, at: "/announcements"
  end
end
