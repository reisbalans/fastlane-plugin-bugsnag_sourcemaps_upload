require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class BugsnagSourcemapsUploadHelper
      # class methods that you define here become available in your action
      # as `Helper::BugsnagSourcemapsUploadHelper.your_method`
      #
      def self.create_bundle(platform, entry_file, path, bundle_path)
        UI.message("Creating React Native bundle")
        Action.sh("npx react-native bundle \
          --dev false \
          --platform #{platform} \
          --bundle-output #{bundle_path} \
          --sourcemap-output #{path} \
          --entry-file #{entry_file}")
      end

      def self.upload_bundle(api_key, platform, app_version, code_bundle_id, path, bundle_path, minified_url, strip, overwrite, wildcard_prefix, upload_sources, upload_modules, endpoint)
        command = "npx bugsnag-source-maps --platform #{platform} upload-react-native --api-key #{api_key} --source-map #{path} "
        if minified_url
          command += "--bundle #{minified_url} "
        else
          if platform == "ios"
            command += "--bundle main.jsbundle "
          else
            command += "--bundle index.android.bundle "
          end
        end
        if app_version
          command += "--app-version=#{app_version} "
        end
        if code_bundle_id
          command += " --code-bundle-id #{code_bundle_id} "
        end
        if endpoint
          command += "--endpoint #{endpoint} "
        end
        UI.message("Uploading React Native bundle to Bugsnag")
        Action.sh(command.to_s)
      end

      def self.show_message
        UI.message("Hello from the bugsnag_sourcemaps_upload plugin helper!")
      end
    end
  end
end
