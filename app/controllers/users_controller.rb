class UsersController < ApiController
  def create
    user = User.create(user_params)
    sign_in(user) if user.persisted?
    respond_with user, serializer: UserApiSerializer
  end

  def show
    if current_user
      respond_with current_user, serializer: UserApiSerializer
    else
      render json: {}, status: 404
    end
  end

  def logout
    sign_out

    render json: true
  end

  def configure_sfdc
    current_user.update_attributes(sfdc_config: params[:sfdc_config], sfdc_setup: true)
    current_user.sfdc_config.each do |type, active|
      SequenceCreator.new(current_user, type).call!
    end
    respond_with current_user
  end

  def email
    EmailWorker.perform_async(current_user.id)

    render json: true
  end

  private

  def user_params
    @user_params ||= params.permit(:name, :organization, :email, :password)
  end

  SequenceCreator = Struct.new(:user, :type) do
    def call!
      if user.sfdc_config[type]
        sequence = create_sequence!
        create_workers(sequence) if new?
      else
        disable_sequence!
      end
    end

    private

    def name
      User::SFDC_FIELDS[type.to_s]
    end

    def new?
      sequence.entries.where(source: "processor", point_time: 30.days.ago..Time.now).count < 20
    end

    def processor
      "Processor::#{name}"
    end

    def sequence
      user.sequences.find_by(processor: processor)
    end

    def create_sequence!
      user.sequences.where(processor: processor).first_or_create!(title: "SFDC #{name}").tap do |sequence|
        sequence.update!(active: true)
      end
    end

    def disable_sequence!
      sequence.update!(active: false) if sequence
    end

    def create_workers(sequence)
      89.times do |i|
        SequenceWorker.perform_async(sequence.id, Time.now - (i+2).days, false)
      end

      SequenceWorker.perform_async(sequence.id, Time.now - 1.days, true)
    end
  end
end
