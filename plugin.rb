# frozen_string_literal: true

enabled_site_setting :announcements_enabled

after_initialize do
  module ::Announcements
    class Engine < ::Rails::Engine
      engine_name "announcements"
      isolate_namespace Announcements
    end
  end

  ::Announcements::Engine.routes.draw do
    get "/admin/plugins/announcements" => "admin_announcements#index"
    post "/admin/plugins/announcements" => "admin_announcements#create"
  end

  Discourse::Application.routes.append do
    mount ::Announcements::Engine, at: "/announcements"
  end

  require_dependency 'application_controller'
  class ::Announcements::AdminAnnouncementsController < ::ApplicationController
    requires_plugin Announcements

    before_action :ensure_admin

    def index
      render json: { announcements: Announcement.all }
    end

    def create
      announcement = Announcement.new(content: params[:content])
      if announcement.save
        SiteSetting.announcements_content = announcement.content
        render json: { message: "Announcement created successfully." }
      else
        render json: { error: "Failed to create announcement." }, status: :unprocessable_entity
      end
    end
  end

  class ::Announcement < ActiveRecord::Base
    validates :content, presence: true
  end

  add_admin_route "admin.announcements.title", "announcements"

  Discourse::PluginRegistry::SiteSetting.add_editable_category "announcements",
    %w[announcements_enabled announcements_content]

  SiteSetting.settings.push :announcements_enabled, :announcements_content
end
