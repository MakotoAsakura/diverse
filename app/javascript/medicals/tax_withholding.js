$(document).on("turbo:load", () => {
    $(".tax-exit").on("click", function () {
        var $form = $($(".tax-exit")[0].closest("td")).find('form')
        let $fromInput = $form.find("#item_from")
        let $fromDefault =  $form.find("#default_from")

        let $toInput = $form.find("#item_to")
        let $toDefault = $form.find("#default_to")

        let $formulaInput = $form.find("#item_formula_data")
        let $formulaDefault =  $form.find("#default_formula_data")

        setDataDefault($fromInput, $fromDefault)
        setDataDefault($toInput, $toDefault)
        setDataDefault($formulaInput, $formulaDefault)
    })

    function setDataDefault(input, defaultInput){
        input.val(defaultInput.val())
    }
})
