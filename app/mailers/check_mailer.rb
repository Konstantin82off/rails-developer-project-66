# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def failure_report(check_id)
    @check = Repository::Check.find(check_id)
    @repository = @check.repository
    @user = @repository.user

    mail(
      to: @user.email,
      subject: "Check failed for #{@repository.full_name}"
    )
  end
end
