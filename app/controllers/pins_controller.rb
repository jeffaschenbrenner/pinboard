class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@pins = Pin.all.order('created_at DESC')
	end

	def show
	end

	def new
		@pin = current_user.pins.build
	end

	def create
		@pin = current_user.pins.build(pin_params)

		if @pin.save
			redirect_to @pin, notice: "Successfully created new Pin"
		else
			render 'new'
		end
	end

	def edit
		if current_user != @pin.user
			redirect_to @pin, notice: "You are not authorized to modify this Pin."
		end
	end

	def update
		if @pin.update(pin_params)
			redirect_to @pin, notice: "Pin was successfully updated!"
		else
			render 'edit'
		end
	end

	def destroy
		@pin.destroy
		redirect_to root_path
	end

	def upvote
		if current_user.voted_up_on? @pin
			@pin.unvote_by current_user
		else
			@pin.upvote_by current_user
		end
		redirect_to :back
	end

	def downvote
		if current_user.voted_down_on? @pin
			@pin.unvote_by current_user
		else
			@pin.downvote_by current_user
		end
		redirect_to :back
	end

	private

	def find_pin
		@pin = Pin.find(params[:id])
	end

	def pin_params
		params.require(:pin).permit(:title, :image, :description)
	end

end
