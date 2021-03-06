using ApproxFunOrthogonalPolynomials, ApproxFunBase, SpecialFunctions, Test
    import ApproxFunBase: testbandedoperator

@testset "Laguerre and WeightedLagueree" begin
    @testset "Evaluation" begin
        f=Fun(Laguerre(0.), [1,2,3])
        @test f(0.1) ≈ 5.215

        f = Fun(Laguerre(0.1), ones(100))
        @test f(0.2) ≈ 8.840040924281498

        x = Fun(Laguerre())
        w = (1+x) * Fun(WeightedLaguerre(),[1.0])
        @test w(0.1) ≈ exp(-0.1)*(1+0.1)
        @test last(w) == 0.0
    end


    @testset "Derivative" begin
        f = Fun(Laguerre(0.1), ones(100))
        @test (Derivative(Laguerre(0.1)) * f)(0.2) ≈ -71.44556705957386

        f = Fun(Laguerre(0.2), ones(100))
        @test (Derivative(Laguerre(0.2)) * f)(0.3) ≈ -137.05785783078218
    end


    @testset "Conversion" begin
        f = Fun(Laguerre(0.2), ones(100))
        @test (Conversion(Laguerre(0.2), Laguerre(1.2)) * f)(0.1) ≈ f(0.1)
        @test (Conversion(Laguerre(0.2), Laguerre(2.2)) * f)(0.1) ≈ f(0.1)
    end


    @testset "Derivative" begin
        f = Fun(LaguerreWeight(0.0, Laguerre(0.1)), ones(100))
        @test f'(0.2) ≈ -65.7322962859456

        B = Evaluation(LaguerreWeight(0.0, Laguerre(0.1)), false)
        @test B*f ≈ 151.53223385808576

        x = Fun(Laguerre(0.0))
        S = WeightedLaguerre(0.0)
        D = Derivative(S)
        u = [ldirichlet(); D^2 - x] \ [airyai(0.0); 0.0]
        @test u(1.0) ≈ airyai(1.0)
    end


    @testset "Multiplication" begin
        w = Fun(WeightedLaguerre(), [1.0])
        @test sum(w) == 1
        t = Fun(identity, space(w))
        @test t(10.0) == 10.0
        M = Multiplication(t^2 + 1, space(w))
        @test (M \ w)(1.0) ≈ exp(-1)/2
    end

    @testset "Multiplication rangespace" begin
        x = Fun(Laguerre())
        w = Fun(WeightedLaguerre(-0.5),[1.0])
        M = Multiplication(w,space(1+x))
        @test rangespace(M) == LaguerreWeight(-0.5,Laguerre())
    end
end
