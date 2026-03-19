require "rails_helper"

RSpec.describe CommentNotifierMailer, type: :mailer do
  describe "comment_created" do
    let(:mail) { CommentNotifierMailer.comment_created }

    it "renders the headers" do
      expect(mail.subject).to eq("Comment created")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
