class MailerExtension < Radiant::Extension
  version "1.0"
  description "Provides support for email forms and generic mailing functionality."
  url "http://github.com/radiant/radiant-mailer-extension"

  define_routes do |map|
    map.resources :mail, :path_prefix => "/pages/:page_id", :controller => "mail"
  end

  def activate
    Page.class_eval do
      include MailerTags
      include MailerProcess
    end
  end
  
  Mail.class_eval do
      def send_jp
        Hash.class_eval do
          def to_yaml_jp
            self.to_a.map {|k,v| "#{k}: #{v}"}.join("\n")
          end

          alias_method :to_yaml_org, :to_yaml
          alias_method :to_yaml, :to_yaml_jp
        end

        return_value = send_org

        Hash.class_eval do
          alias_method :to_yaml, :to_yaml_org
        end

        return_value
      end

      alias_method :send_org, :send
      alias_method :send, :send_jp
    end

end