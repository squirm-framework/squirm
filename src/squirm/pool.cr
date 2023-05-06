module Squirm
  class Pool
    def initialize(@size : Int32)
      @jobs = Channel(Proc(Nil)).new
      @done = Channel(Nil).new

      (1..@size).each do
        ::spawn do
          while job = @jobs.receive?
            job.call
          end
          @done.send nil
        end
      end
    end

    def spawn(&block)
      @jobs.send block
    end

    def wait
      @jobs.close
      (1..@size).each do
        @done.receive
      end
      @done.close
    end
  end
end
