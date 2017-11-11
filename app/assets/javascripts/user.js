var UserModule = function () {

    var handleValidationAdd = function() {
    	// for more info visit the official plugin documentation: 
            // http://docs.jquery.com/Plugins/Validation
            $.validator.addMethod("username",function(value,element){
				return this.optional(element) || /^[a-zA-Z0-9._-]{4,20}$/i.test(value);
			},"Username are 4-20 characters.Not to allow special characters and space");

			$.validator.addMethod("password",function(value,element){
				return this.optional(element) || /^[a-zA-Z0-9._-]{4,20}$/i.test(value);
			},"Password are 4-20 characters.Not to allow special characters and space");

            var form1 = $('#form_user_add');
            var error1 = $('.alert-danger', form1);
            var success1 = $('.alert-success', form1);

            form1.validate({
                errorElement: 'span', //default input error message container
                errorClass: 'help-block help-block-error', // default input error message class
                focusInvalid: false, // do not focus the last invalid input
                ignore: "",  // validate all fields including form hidden input
                messages: {
                    'user[user_name]': {
                        maxlength: jQuery.validator.format("Max 20"),
                        minlength: jQuery.validator.format("At least {0} characters must be enter")
                    },
                    'user[password]': {
                        maxlength: jQuery.validator.format("Max 20"),
                        minlength: jQuery.validator.format("At least {0} characters must be enter")
                    },

                },
                rules: { 
                    'user[user_name]': {
                        required: true,
                        minlength: 4,
                        maxlength: 20,
                        username: true

                    },
                    'user[password]': {
                        required: true,
                        password: true
                    }

                },

                invalidHandler: function (event, validator) { //display error alert on form submit              
                    success1.hide();
                    error1.show();
                    App.scrollTo(error1, -200);
                },

                errorPlacement: function (error, element) { // render error placement for each input type
                    
                    element.after(error);
                },

                highlight: function (element) { // hightlight error inputs

                    $(element)
                        .closest('.form-group').addClass('has-error'); // set error class to the control group
                },

                unhighlight: function (element) { // revert the change done by hightlight
                    $(element)
                        .closest('.form-group').removeClass('has-error'); // set error class to the control group
                },

                success: function (label) {
                    label
                        .closest('.form-group').removeClass('has-error'); // set success class to the control group
                },

                submitHandler: function (form) {
                    //success1.show();
                    //error1.hide();
                    form.submit();
                }
            });
    }

    return {
        //main function to initiate the module
        init: function () {
          handleValidationAdd();
        },
        initValidateAdd: function() {
        	handleValidationAdd();
        }
    };

}();

jQuery(document).ready(function() {    
    UserModule.init();
});