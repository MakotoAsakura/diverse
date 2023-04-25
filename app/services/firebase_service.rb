# frozen_string_literal: true

require "google/cloud/firestore"
require "jwt"

class FirebaseService
  def connect
    Google::Cloud::Firestore.new(
      project_id: "medical-919ec",
      credentials: Rails.root.join("firebase_key.json")
    )
  end

  def create_custom_token(uid)
    now_seconds = Time.now.to_i
    service_account_email = ENV.fetch("FIREBASE_ACCOUNT_EMAIL") { nil } # rubocop:disable Style/RedundantFetchBlock
    private_key = OpenSSL::PKey::RSA.new(ENV["FIREBASE_PRIVATE_KEY"].to_s.gsub('\n', "\n"))
    payload = { iss: service_account_email,
                sub: service_account_email,
                aud: ENV.fetch("FIREBASE_AUD") { nil }, # rubocop:disable Style/RedundantFetchBlock
                iat: now_seconds,
                exp: now_seconds + (60 * 60), # Maximum expiration time is one hour
                uid: uid.to_s }

    JWT.encode payload, private_key, "RS256"
  end
end
