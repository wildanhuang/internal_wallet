class MutationSerializer < ActiveModel::Serializer
  attributes :date, :type, :nominal, :balance

  def date
    object.created_at.strftime("%d %b %Y")
  end

  def type
    if object.receiver_id == @instance_options[:user].id
      "CREDIT"
    else
      "DEBIT"
    end
  end
end
