## R CMD check results

0 errors | 0 warnings | 0 note

* This is a new release.

> Please omit the redundant "through R" at the end/start of your title and description.

Done, thank you.

>The Description field is intended to be a (one paragraph) description of what the package does and why it may be useful. Please add more details about the package functionality and implemented methods in your Description text.
>For more details:
><https://contributor.r-project.org/cran-cookbook/general_issues.html#description-length>

We added more details, thank you.


> Please add a web reference for the API in the form <https:.....> to the description of the DESCRIPTION file with no space after 'https:' and angle brackets for auto-linking.
> For more details:
> <https://contributor.r-project.org/cran-cookbook/description_issues.html#references>

We added a link to the API, thank you.

> Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation. Please write about the structure of the output (class) and also what the output means. (If a function does not return a value, please document that too, e.g.
> \value{No return value, called for side effects} or similar) For more details:
> <https://contributor.r-project.org/cran-cookbook/docs_issues.html#missing-value-tags-in-.rd-files>
> Missing Rd-tags:
>      pipe.Rd: \value

Thank you, we removed the magrittr dependency in favor of using the base R pipe so this manual page disappeared.

> "Using foo:::f instead of foo::f allows access to unexported objects.
> This is generally not recommended, as the semantics of unexported objects may be changed by the package > author in routine maintenance."
> Used ::: in documentation:
> Please omit one colon.

Our package now exports this function. 