# encoding: utf-8

module Yast
  class ExampleClient < Client
    def main
      Yast.import "UI"

      create_widgets
      widget = UI.UserInput

      if widget == :cancel # WM_CLOSE (Alt-F4)
        UI.CloseDialog
        return
      end

      result = fetch_result # As long as the widget still exists!
      UI.CloseDialog
      show_result(result)
    end

    protected

    def custom_states
      [
        # Icon, NCursesIndicator, NextStatus
        ["checkbox-off", "[ ]", 1],
        ["checkbox-on",  "[x]", 0]
      ]
    end

    def items
      [
        # Notice no item IDs, so we'll get the item label as the result.
        # Also no descriptions.
        Item("Pizza Margherita"      ),
        Item("Pizza Capricciosa"     ),
        Item("Pizza Funghi"          ),
        Item("Pizza Prosciutto"      ),
        Item("Pizza Quattro Stagioni"),
        Item("Calzone"               )
      ]
    end

    def create_widgets
      UI.OpenDialog(
        VBox(
          CustomStatusItemSelector(Id(:pizza), custom_states, items),
          PushButton("&OK")
        )
      )
    end

    def fetch_result
      UI.QueryWidget(:pizza, :SelectedItems)
    end

    def show_result(result)
      result = result.join(", ")
      result = "(nothing)" if result.empty?

      # Show the result in a pop-up dialog
      UI.OpenDialog(
        VBox(
          Label("\n  Selected:\n\n  #{result}  \n"),
          PushButton("&OK")
        )
      )
      UI.UserInput
      UI.CloseDialog

      nil
    end
  end
end

Yast::ExampleClient.new.main
