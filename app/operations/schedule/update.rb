class Operations::Schedule::Update
  def validate!
    Operations::Validators::Update.validate
  end
end